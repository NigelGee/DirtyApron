//
//  AddCategoryView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 28/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var categories: Categories
    
    @State var category: Category
    @State private var loading = false
    @State private var showingAlert = false
    @State private var message = ""
   
    var isEdit: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
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
                if loading {
                    LoadingView(text: "Saving...", spinner: true)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("ERROR"), message: Text(message), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("\(isEdit ? "Edit" : "Add New") Category", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Dismiss") {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button("Submit") {
                        if self.isEdit {
                            self.modify()
                        } else {
                            self.submit()
                        }
                    }.disabled(category.name == ""))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
// MARK: Add Categories
    private func submit() {
        loading.toggle()
        category.position = (categories.lists.last?.position ?? 0) + 1
        
        CKCategory.save(category: self.category) { (result) in
            switch result {
            case .success(let newCategory):
                self.categories.lists.append(newCategory)
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loading.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
// MARK: Modify Categories
    private func modify() {
        loading.toggle()
        CKCategory.modify(category: category) { (result) in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loading.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(categories: Categories(), category: Category(), isEdit: false)
    }
}
