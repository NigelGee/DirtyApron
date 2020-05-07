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
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userDetails: UserDetails
    
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
        VStack {
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
            
            NavigationLink(destination: CheckoutView(userDetails: userDetails)) {
                Text("Confirm")
            }
            .styleButton(colour: .blue)
            .padding()
        }
        .navigationBarTitle("Order")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button("Cancel") {
                    self.cancel()
                },
            trailing:
                Text("Total: £\(totalAmount, specifier: "%.2f")")
            )
    }
    
    func cancel() {
        orders.list = []
        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteOrder(at offsets: IndexSet) {
        self.orders.list.remove(atOffsets: offsets)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(userDetails: UserDetails())
    }
}
