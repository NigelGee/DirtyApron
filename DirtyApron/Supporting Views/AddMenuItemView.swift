//
//  AddMenuItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AddMenuItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var menuItems: MenuItems
  
    
    @State var menuItem: MenuItem
    @State var height: CGFloat = 0
    @State private var showingAddType = false
    @State private var type = ""
    @State private var amount = ""
    
    var isEdit: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $menuItem.isEnable) {
                        Text("Enable")
                    }
                }
                
                Section {
                    TextField("Enter Name", text: $menuItem.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    ResizableTextField(title: "Enter Description", text: $menuItem.description, height: $height)
                        .frame(height: height)
                        .background(Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 1))
                    
                    HStack {
                        TextField("GF, VE, VG, OR, HL", text: $type)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                            self.menuItem.foodType.append(self.type.uppercased())
                            self.type = ""
                        }
                        .disabled(type == "")
                    }
                    
                    HStack {
                        ForEach(menuItem.foodType, id: \.self) { type in
                            Text(type)
                                .badgesStyle(text: type)
                        }
                    }
                    
                    TextField("Amount", text: $amount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Picture")) {
                    Text("Add Picture here")
                }
            }
            .navigationBarTitle("Add New Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Submit") {
                self.saveItem()
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func saveItem() {
        if let actualAmount = Double(self.amount) {
            let item = MenuItem(name: menuItem.name, description: menuItem.description, amount: actualAmount, isEnable: menuItem.isEnable, foodType: menuItem.foodType)
            menuItems.lists.append(item)
        } else {
            print("Invalid Amount")
        }
    }
}

struct AddMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuItemView(menuItems: MenuItems(), menuItem: MenuItem(), isEdit: true)
    }
}
