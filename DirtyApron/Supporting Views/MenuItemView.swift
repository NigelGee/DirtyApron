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
                }
            }
        }
        .sheet(isPresented: $showingAddMenuItem) {
            AddMenuItemView(menuItems: self.menuItems, menuItem: self.menuItem, isEdit: self.isEdit)
        }
        .navigationBarTitle(category.name)
        .navigationBarItems(
            trailing:
                Button(action: {
                    self.showingAddMenuItem.toggle()
                }) {
                    Image(systemName: "plus")
                }
        )
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
