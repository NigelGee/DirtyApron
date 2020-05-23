//
//  AdminView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    @State private var adminUsers = AdminUsers()
    @State private var showingCategory = false
    @State private var showingAlert = false
    @State private var title = ""
    @State private var message = ""
    @State private var enteredName = ""
    @State private var enteredPassword = ""
    @State private var allAccess = false
        
    var body: some View {
        ZStack {
            if showingCategory {
                CategoryView(adminUsers: adminUsers, allAccess: self.allAccess)
            } else {
                VStack {
                    Group {
                        Text("We update all the yummies food item here.")
                            .padding(.top)
                        Text("Go to menu to see them!")
                        Group {
                            Image(systemName: "doc.plaintext")
                                .font(.largeTitle)
                            Text("Menu")
                                .font(.body)
                            }
                        .accessibilityElement(children: .ignore)
                    }
                    .foregroundColor(.secondary)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    
                    TextField("User Name", text: $enteredName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    SecureField("Password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Enter") {
                        self.checkID()
                    }
                    .styleButton(colour: .blue, padding: 10)
                    .padding()
                    
                    
                    Spacer()
                    
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
                }
            }
        }
        .onAppear(perform: onLoad)
    }
    
    private func onLoad() {
        CKAdmin.fetch { (result) in
            switch result {
            case .success(let adminUsers):
                self.adminUsers.list = adminUsers
            case .failure(let error):
                self.title = "ERROR!"
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
    
    private func checkID() {
        for user in adminUsers.list {
            if user.name == enteredName && user.password == enteredPassword {
                self.allAccess = user.allAccess
                showingCategory.toggle()
                return
            }
        }
        title = "Wrong Name or Password"
        message = "Please try again!"
        showingAlert.toggle()
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
