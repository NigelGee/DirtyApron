//
//  CategoryView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 28/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var categories: Categories
    
    @State private var isEdit = false
    @State private var addNewCategory = false
    @State private var item = Category()
    @State private var showingAlert = false
    @State private var message = ""
    @State private var loading = false
    @State private var change = false
    
    var adminUsers: AdminUsers
    @State var allAccess: Bool
    
    var body: some View {
        ZStack {
            List {
                ForEach(categories.lists, id: \.id) { category in
                    NavigationLink(destination: MenuItemView(category: category)) {
                        Text(category.name)
                            .fontWeight(category.isEnable ? .bold : .none)
                            .foregroundColor(category.isEnable ? .primary : .secondary)
                            .onTapGesture(count: 2) {
                                self.item = category
                                self.isEdit = true
                                self.addNewCategory.toggle()
                        }
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            
            if categories.lists.isEmpty && loading {
                withAnimation {
                    LoadingView(text: "Loading...", spinner: true)
                }
                .animation(.easeOut(duration: 1))
            }
            
            if change {
                withAnimation {
                    LoadingView(text: "Saving...", spinner: true)
                }
                .animation(.easeOut(duration: 1))
            }
            
        }
        .onAppear(perform: loadCategories)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $addNewCategory) {
            AddCategoryView(categories: self.categories, category: self.item, isEdit: self.isEdit)
        }
        .navigationBarTitle("Categories", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
            Group{
                if allAccess {
                    NavigationLink(destination: AdminUserView(adminUsers: self.adminUsers)) {
                        Text("Admin Users")
                    }
                }
            },
            trailing:
                HStack {
                    EditButton()
                    
                    Button(action: {
                        self.item = Category()
                        self.isEdit = false
                        self.addNewCategory.toggle()
                    }){
                        Image(systemName: "plus")
                    }
                    .padding()
                }
            )
    }
    // MARK: Fetch Categories
    private func loadCategories() {
        loading.toggle()
        CKCategory.fetch { (results) in
            switch results {
            case .success(let newCategories):
                self.categories.lists = newCategories
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
            self.loading.toggle()
        }
    }
    // MARK: Delete Categories
    private func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let recordID = categories.lists[index].recordID else { return }
        
        CKHelper.delete(index: index, recordID: recordID) { (result) in
            switch result {
            case .success(let index):
                self.categories.lists.remove(at: index)
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
    //MARK: Move Categories
    private func move(indexSet: IndexSet, destination: Int) {
        guard let source = indexSet.first else { return }
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startPosition = categories.lists[source].position
            while startIndex <= endIndex {
                let recordID = categories.lists[startIndex].recordID
                let name = categories.lists[startIndex].name
                let isEnable = categories.lists[startIndex].isEnable
                let newPosition = startPosition
                let newItem = Category(recordID: recordID, position: newPosition, name: name, isEnable: isEnable)
                saveMove(item: newItem)
                startPosition += 1
                startIndex += 1
            }
            let recordID = categories.lists[source].recordID
            let name = categories.lists[source].name
            let isEnable = categories.lists[source].isEnable
            let newPosition = destination
            let newItem = Category(recordID: recordID, position: newPosition, name: name, isEnable: isEnable)
            saveMove(item: newItem)
            categories.lists.move(fromOffsets: indexSet, toOffset: destination)
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startPosition = categories.lists[destination].position + 1
            let newPosition = categories.lists[destination].position
            while startIndex <= endIndex {
                let recordID = categories.lists[startIndex].recordID
                let name = categories.lists[startIndex].name
                let isEnable = categories.lists[startIndex].isEnable
                let position = startPosition
                let newItem = Category(recordID: recordID, position: position, name: name, isEnable: isEnable)
                saveMove(item: newItem)
                startPosition += 1
                startIndex += 1
            }
            let recordID = categories.lists[source].recordID
            let name = categories.lists[source].name
            let isEnable = categories.lists[source].isEnable
            let newItem = Category(recordID: recordID, position: newPosition, name: name, isEnable: isEnable)
            saveMove(item: newItem)
            categories.lists.move(fromOffsets: indexSet, toOffset: destination)
        }
    }
    
    private func saveMove(item: Category) {
        change = true
        CKCategory.modify(category: item) { (result) in
            switch result {
            case .success(let editItem):
                for i in 0..<self.categories.lists.count {
                    let currentItem = self.categories.lists[i]
                    if currentItem.recordID == editItem.recordID {
                        self.categories.lists[i] = editItem
                    }
                }
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
            self.change = false
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(adminUsers: AdminUsers(), allAccess: true)
    }
}
