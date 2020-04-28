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
    @State private var addNewCategory = false
    
    var body: some View {
        List {
            ForEach(categories.lists, id: \.id) { item in
                Text(item.name)
                    .foregroundColor(item.isEnable ? .primary : .secondary)
            }
        }
        .onAppear(perform: loadCategories)
        .sheet(isPresented: $addNewCategory) {
            AddCategoryView(categories: self.categories)
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
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
