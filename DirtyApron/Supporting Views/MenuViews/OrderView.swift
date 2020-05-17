//
//  OrderView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 07/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var orders: Orders
    
    @ObservedObject var user: UserDetails
    
    @State private var showingCheckout = false
    @State private var takeaway = false
    @State private var note = ""
    @State private var height: CGFloat = 0
    
    
    var totalAmount: Double {
        var total = 0.0
        for order in orders.list {
            total += order.amount
        }
        return total
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if orders.list.isEmpty {
                    Group {
                        Image(systemName: "bag")
                            .font(.largeTitle)
                        Text("No Orders")
                        Text("Your entered order will appear here")
                            .font(.body)
                            .padding(10)
                    }
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(orders.list, id: \.id) { order in
                            HStack {
                                Text(order.name)
                                Spacer()
                                Text("£\(order.amount, specifier: "%.2f")")
                            }
                        }
                        .onDelete(perform: deleteOrder)
                    }
                    Button("Confirm") {
                        self.showingCheckout.toggle()
                    }
                    .styleButton(colour: .blue)
                    .padding()
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutView(orders: self.orders, userDetails: self.user)
            }
            .navigationBarTitle("Total: £\(totalAmount, specifier: "%.2f")", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        self.orders.list = []
                    },
                trailing:
                    EditButton()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func deleteOrder(at offsets: IndexSet) {
        self.orders.list.remove(atOffsets: offsets)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(user: UserDetails())
    }
}
