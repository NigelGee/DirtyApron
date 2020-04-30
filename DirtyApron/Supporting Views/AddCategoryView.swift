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

    
    @State var category: Category
   
    var isEdit: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $category.isEnable) {
                        Text("Enable")
                    }
                }
                
                Section(header: Text("Category Name")){
                    TextField("Enter Name", text: $category.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationBarTitle("Add New Category", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button("Submit"){
                        if self.isEdit {
                            self.modify()
                        } else {
                            self.submit()
                        }
                    })
        }
    }
// MARK: Add Categories
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
// MARK: Modify Categories
    func modify() {
        guard let recordID = category.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let record = record else { return }
                record["name"] = self.category.name as CKRecordValue
                record["isEnable"] = self.category.isEnable as CKRecordValue
                record["position"] = self.category.position as CKRecordValue
                
                CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
                    if let error = error {
                        print(error.localizedDescription)
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
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(categories: Categories(), category: Category(), isEdit: false)
    }
}
