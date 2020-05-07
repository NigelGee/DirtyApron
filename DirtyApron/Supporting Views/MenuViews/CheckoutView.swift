//
//  CheckoutView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 07/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var userDetails: UserDetails
    
    @State private var takeaway = false
    @State private var note = ""
    @State private var height: CGFloat = 0
    
    var body: some View {
        Form {
            Toggle(isOn: $takeaway) {
                Text("Take-a-Way")
            }
            
            TextField("Enter Name", text: $userDetails.user.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if takeaway {
                Section(header: Text("Address")) {
                    TextField("Street", text: $userDetails.user.street1)
                    TextField("", text: $userDetails.user.street2)
                    TextField("City", text: $userDetails.user.city)
                    TextField("Postcode", text: $userDetails.user.zip)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Section(header: Text("Additional Notes")) {
                ResizableTextField(title: "Enter Additional Notes", text: $note, height: $height)
            }
            
            Button("Checkout") {
                // action
            }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(userDetails: UserDetails())
    }
}
