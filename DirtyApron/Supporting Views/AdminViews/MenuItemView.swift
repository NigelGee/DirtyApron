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
                NavigationLink(destination: DetailItemView(menuItem: menuItem)){
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
                        Group {
                            if menuItem.amount != 0 {
//                                Text("£\(menuItem.amount, specifier: "%.2f")")
                                Button(action : {
                                    print("\(menuItem.name) - £\(menuItem.amount)")
                                }) {
                                    
                                    Text("£\(menuItem.amount, specifier: "%.2f")")
                                        .styleButton(colour: .blue)
                                    
                                }
                                .padding(.leading)
                                .buttonStyle(PlainButtonStyle())
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
                    self.showingAddMenuItem.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .padding()
        })
    }
    
    //MARK: Fetch Menu Items
    func loadItems() {
        if let recordID = category.recordID {
            CKHelper.fetchItems(recordID: recordID) { (results) in
                switch results {
                case .success(let newItems):
                    self.menuItems.lists = newItems
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
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
