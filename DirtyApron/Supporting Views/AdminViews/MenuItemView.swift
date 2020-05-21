//
//  MenuItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct MenuItemView: View {
    @EnvironmentObject var menuItems: MenuItems
    
    @State var menuItem = MenuItem()
    @State private var showingAddMenuItem = false
    @State private var isEdit = false
    @State private var showingAlert = false
    @State private var loading = false
    @State private var message = ""
    @State var pickedType = [String]()
    var category: Category!
    
    var body: some View {
        ZStack {
            List {
                ForEach(menuItems.lists, id: \.id) { menuItem in
                    NavigationLink(destination: DetailItemView(menuItem: menuItem)){
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(menuItem.name)
                                    .fontWeight(menuItem.isEnable ? .bold : .none)
                                    .foregroundColor(menuItem.isEnable ? .primary : .secondary)
                                    .font(.headline)
                                HStack {
                                    ForEach(menuItem.foodType.sorted(), id: \.self) {
                                        Text($0)
                                            .badgesStyle(text: $0)
                                    }
                                }
                            }
                            
                            Spacer()
                            Group {
                                if menuItem.amount != 0 {
                                    Text("£\(menuItem.amount, specifier: "%.2f")")
                                } else {
                                    Text(" INFO")
                                }
                            }
                        }
                        .onTapGesture(count: 2) {
                            self.menuItem = menuItem
                            self.isEdit = true
                            self.showingAddMenuItem.toggle()
                        }
                    }
                }
                .onDelete(perform: deleteItem)
            }
            
            if loading {
                withAnimation {
                    LoadingView(text: "Loading...", spinner: true)
                }
                .animation(.easeOut)
            }
        }
        .onAppear(perform: loadItems)
        .sheet(isPresented: $showingAddMenuItem) {
            AddMenuItemView(menuItems: self.menuItems, menuItem: self.menuItem, amount: (self.menuItem.amount == 0 ? "" : String(self.menuItem.amount)), category: self.category, isEdit: self.isEdit)
        }
        .navigationBarTitle(category.name)
        .navigationBarItems(
            trailing:
            HStack {
                EditButton()
                
                Button(action: {
                    self.isEdit = false
                    self.menuItem = MenuItem()
                    self.showingAddMenuItem.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .padding()
        })
    }
    
    //MARK: Fetch Menu Items
    private func loadItems() {
        loading.toggle()
        if let recordID = category.recordID {
            CKHelper.fetchItems(recordID: recordID) { (results) in
                switch results {
                case .success(let newItems):
                    self.menuItems.lists = newItems
                case .failure(let error):
                    self.message = error.localizedDescription
                    self.showingAlert.toggle()
                }
                self.loading.toggle()
            }
        }
    }
    
    //MARK: Delete Menu Item
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let recordID = menuItems.lists[index].recordID else { return }
        
        CKHelper.delete(index: index, recordID: recordID) { (result) in
            switch result {
            case .success(let index):
                self.menuItems.lists.remove(at: index)
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
