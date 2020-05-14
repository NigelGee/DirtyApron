//
//  AdminView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    @State private var showingCategory = false
    @State private var showingAlert = false
    @State private var userID = ""
    @State private var password = ""
    
    let id = "Admin"
    let pass = "Admin1"
    
    var body: some View {
        ZStack {
            if showingCategory {
                CategoryView()
            } else {
                VStack {
                    Group {
                        Text("We update all the yummies food item here.")
                            .padding(.top)
                        Text("Go to menu to see them!")
                        Image(systemName: "doc.plaintext")
                            .font(.largeTitle)
                        Text("Menu")
                            .font(.body)
                    }
                    .foregroundColor(.secondary)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    
                    
                    Spacer()
                    
                    TextField("User ID", text: $userID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Enter") {
                        if self.userID == self.id && self.password == self.pass {
                            self.showingCategory.toggle()
                        } else {
                            self.showingAlert.toggle()
                        }
                    }
                    .styleButton(colour: .blue, padding: 10)
                    .padding()
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Wrong ID or Passcode"), message: Text("Please try again!"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
