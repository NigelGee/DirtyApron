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
    
    var body: some View {
        List {
            ForEach(categories.lists, id: \.id) { item in
                Text(item.name)
                    .foregroundColor(item.isEnable ? .primary : .secondary)
                    .onTapGesture(count: 2) {
                        self.item = item
                        self.isEdit = true
                        self.addNewCategory.toggle()
                    }
            }
            .onDelete(perform: delete)
        }
        .onAppear(perform: loadCategories)
        .sheet(isPresented: $addNewCategory) {
            AddCategoryView(categories: self.categories, category: self.item, isEdit: self.isEdit)
        }
        .navigationBarTitle("Categories", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.addNewCategory.toggle()
        }){
            Image(systemName: "plus")
        })
    }
    
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
                if error == nil {
                    self.categories.lists = newCategories
                } else {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let recordID = categories.lists[index].recordID else { return }
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.categories.lists.remove(at: index)
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
