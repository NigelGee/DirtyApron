//
//  AddCategoryView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 28/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var categories: Categories
    
    @State private var category = Category()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $category.isEnable) {
                        Text("Enable")
                    }
                    
                    TextField("Category Name", text: $category.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section{
                    Button("Submit") {
                        self.submit()
                    }
                }
            }
            .navigationBarTitle("Add New Category", displayMode: .inline)
        }
    }
    
    func submit() {
        category.position = (categories.lists.last?.position ?? 0) + 1
        
        let categoryRecord = CKRecord(recordType: "Categories")
        
        categoryRecord["name"] = category.name as CKRecordValue
        categoryRecord["isEnable"] = category.isEnable as CKRecordValue
        categoryRecord["position"] = category.position as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(categoryRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.categories.lists.append(self.category)
                }
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(categories: Categories())
    }
}
