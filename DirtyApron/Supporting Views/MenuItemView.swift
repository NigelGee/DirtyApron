//
//  MenuItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct MenuItemView: View {
    @EnvironmentObject var menuItems: MenuItems
     
    @State var menuItem = MenuItem()
    @State private var showingAddMenuItem = false
    @State private var isEdit = false
    @State var pickedType = [String]()
    var category: Category!
    
    var body: some View {
        List {
            ForEach(menuItems.lists, id: \.id) { menuItem in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(menuItem.name)
                            .fontWeight(menuItem.isEnable ? .bold : .none)
                            .foregroundColor(menuItem.isEnable ? .primary : .secondary)
                            .font(.headline)
                            .bold()
                        HStack {
                            ForEach(menuItem.foodType, id: \.self) {
                                Text($0)
                                    .badgesStyle(text: $0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("£\(menuItem.amount, specifier: "%.2f")")
                        .styleButton(colour: .blue)
                }
                .onTapGesture(count: 2) {
                    self.menuItem = menuItem
                    self.isEdit = true
                    self.showingAddMenuItem.toggle()
                }
            }
            .onDelete(perform: deleteItem)
        }
        .onAppear(perform: fetchItems)
        .onDisappear(perform: disappear)
        .sheet(isPresented: $showingAddMenuItem) {
            AddMenuItemView(menuItems: self.menuItems, menuItem: self.menuItem, amount: String(self.menuItem.amount), category: self.category, isEdit: self.isEdit)
        }
        .navigationBarTitle(category.name)
        .navigationBarItems(
            trailing:
                HStack {
                    EditButton()
                    
                    Button(action: {
                        self.showingAddMenuItem.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                })
    }
    
    func disappear() {
        self.menuItems.lists = []
    }
//MARK: Fetch Menu Items
    func fetchItems() {
        if let recordID = category.recordID {
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            let predicate = NSPredicate(format: "owningCategory == %@", reference)
            let sort = NSSortDescriptor(key: "creationDate", ascending: true)
            let query = CKQuery(recordType: "Items", predicate: predicate)
            query.sortDescriptors = [sort]
            
            let operation = CKQueryOperation(query: query)
            operation.desiredKeys = ["isEnable", "name", "description","foodType", "amount"]
            operation.resultsLimit = 50
            
            var newItems = [MenuItem]()
            
            operation.recordFetchedBlock = { record in
                var item = MenuItem()
                item.recordID = record.recordID
                item.isEnable = record["isEnable"] as! Bool
                item.name = record["name"] as! String
                item.description = record["description"] as! String
                item.foodType = record["foodType"] as! [String]
                item.amount = record["amount"] as! Double
                newItems.append(item)
            }
            
            operation.queryCompletionBlock = { (cursor, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.menuItems.lists = newItems
                    }
                }
            }
            CKContainer.default().publicCloudDatabase.add(operation)
        }
    }
    
//MARK: Delete Menu Item
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let recordID = menuItems.lists[index].recordID else { return }
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.menuItems.lists.remove(at: index)
                }
            }
        }
        
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
