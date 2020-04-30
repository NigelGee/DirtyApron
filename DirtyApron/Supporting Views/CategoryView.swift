//
//  CategoryView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 28/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct CategoryView: View {
    @EnvironmentObject var categories: Categories
    
    @State private var isEdit = false
    @State private var addNewCategory = false
    @State private var item = Category()
    @State private var showingAlert = false
    @State private var message = ""
    
    var body: some View {
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
        .onAppear(perform: loadCategories)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $addNewCategory) {
            AddCategoryView(categories: self.categories, category: self.item, isEdit: self.isEdit)
        }
        .navigationBarTitle("Categories", displayMode: .inline)
        .navigationBarItems(
                trailing:
                    HStack {
                        EditButton()
                        
                        Button(action: {
                            self.addNewCategory.toggle()
                        }){
                            Image(systemName: "plus")
                        }
                        .padding()
                    })
    }
// MARK: Fetch Categories
    func loadCategories() {
        let predicate = NSPredicate(value: true)
        let position = NSSortDescriptor(key: "position", ascending: true)
        let name = NSSortDescriptor(key: "name", ascending: true)
        let query = CKQuery(recordType: "Categories", predicate: predicate)
        query.sortDescriptors = [position, name]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "isEnable", "position"]
        operation.resultsLimit = 50
        
        var newCategories = [Category]()
        
        operation.recordFetchedBlock = { record in
            var category = Category()
            category.recordID = record.recordID
            category.name = record["name"] as! String
            category.isEnable = record["isEnable"] as! Bool
            category.position = record["position"] as! Int
            newCategories.append(category)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = error.localizedDescription
                    self.showingAlert.toggle()
                } else {
                    self.categories.lists = newCategories
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
// MARK: Delete Categories
    func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let recordID = categories.lists[index].recordID else { return }
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = error.localizedDescription
                    self.showingAlert.toggle()
                } else {
                    self.categories.lists.remove(at: index)
                }
            }
        }
    }
//MARK: Move Categories
    func move(indexSet: IndexSet, destination: Int) {
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
    
    func saveMove(item: Category) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            } else {
                guard let record = record else { return }
                record["name"] = item.name as CKRecordValue
                record["isEnable"] = item.isEnable as CKRecordValue
                record["position"] = item.position as CKRecordValue
                
                CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
                    if let error = error {
                        self.message = error.localizedDescription
                        self.showingAlert.toggle()
                    } else {
                        guard let record = record else { return }
                        let recordID = record.recordID
                        guard let name = record["name"] as? String else { return }
                        guard let isEnable = record["isEnable"] as? Bool else { return }
                        guard let position = record["position"] as? Int else { return }
                        
                        let editItem = Category(recordID: recordID, position: position, name: name, isEnable: isEnable)
                        
                        DispatchQueue.main.async {
                            for i in 0..<self.categories.lists.count {
                                let currentItem = self.categories.lists[i]
                                if currentItem.recordID == editItem.recordID {
                                    self.categories.lists[i] = editItem
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
