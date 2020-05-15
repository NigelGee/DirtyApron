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
    @EnvironmentObject var orders: Orders
    
    @State var menuItem = MenuItem()
    @State private var loading = false
    @State private var showingAlert = false
    @State private var showingAdded = false
    @State private var message = ""
    
    var category: Category!
    
    var body: some View {
        ZStack {
            List {
                ForEach(menuItems.lists.filter(\.isEnable), id: \.id) { menuItem in
                    NavigationLink(destination: DetailItemView(menuItem: menuItem)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(menuItem.name)
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                HStack {
                                    ForEach(menuItem.foodType.sorted(), id: \.self) { type in
                                        Text(type)
                                            .badgesStyle(text: type)
                                            .accessibility(label: Text(MenuItems.typeFullName[type, default: type]))
                                    }
                                }
                            }
                            Spacer()
                            Group {
                                if menuItem.amount != 0 {
                                    Button(action : {
                                        let item = Order(name: menuItem.name, amount: menuItem.amount)
                                        self.orders.list.append(item)
                                        self.showingAdded.toggle()
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
            .blur(radius: showingAdded ? 3 : 0)
            
            if loading {
                withAnimation {
                    LoadingView(text: "Getting \(category.name) Items", spinner: true)
                        .multilineTextAlignment(.center)
                }
                .animation(.easeInOut(duration: 1))
            }
            
            if showingAdded {
                LoadingView(text: "Added", spinner: false)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.showingAdded.toggle()
                        }
                }
            }
        }
        .onAppear(perform: loadItems)
        .navigationBarTitle(category.name)
        .navigationBarItems(
            trailing:
            ZStack {
                Text("\(orders.list.count)")
                    .font(.callout)
                    .offset(x: 0, y: 4)
                
                Image(systemName: "bag")
                    .font(.title)
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("\(orders.list.count) in bag"))
        )
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
