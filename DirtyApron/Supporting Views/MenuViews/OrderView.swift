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
    @State private var takeaway = false
    
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
            }
            
            Form {
                Toggle(isOn: $takeaway) {
                    Text("Take-a-Way")
                }
                
                // Name
                
                if takeaway {
                    // Address
                }
                // Note
                
                Button("Confirm") {
                    
                }
            }
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
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
