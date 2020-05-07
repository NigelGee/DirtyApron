//
//  ItemsView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 03/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var menuItems: MenuItems
    
    @State var menuItem = MenuItem()
    @State private var loading = false
    @State private var showingAlert = false
    @State private var message = ""
    
    var category: Category!
    
    var body: some View {
        List {
            ForEach(menuItems.lists, id: \.id) { menuItem in
                NavigationLink(destination: DetailItemView(menuItem: menuItem)) {
                    HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(menuItem.name)
                            .font(.headline)
                        HStack {
                            ForEach(menuItem.foodType.sorted(), id: \.self) {
                                Text($0)
                                    .badgesStyle(text: $0)
                            }
                        }
                    }
                    Spacer()
                    Group {
                        if menuItem.amount != 0 {
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
                }
            }
        }
        .onAppear(perform: loadItems)
        .navigationBarTitle(category.name)
        .navigationBarItems(trailing: Button(action: {
            
        }) {
            ZStack {
                Text("0")
                    .font(.callout)
                    .foregroundColor(.red)
                    .offset(x: 0, y: 4)
                Image(systemName: "bag")
                    .font(.title)
            }
        })
    }
    
    private func loadItems() {
           loading.toggle()
           if let recordID = category.recordID {
               CKHelper.fetchItems(recordID: recordID) { (results) in
                   switch results {
                   case .success(let newItems):
                       self.menuItems.lists = newItems
                   case .failure(let error):
                       self.message = error.localizedDescription
                       self.showingAlert.toggle()
                   }
                   self.loading.toggle()
               }
           }
       }
    
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
