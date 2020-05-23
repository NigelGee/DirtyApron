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
                    
                    Spacer()
                    
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
                    Spacer()
                    Spacer()
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Wrong Name or Password"), message: Text("Please try again!"), dismissButton: .default(Text("OK")))
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
                print(error.localizedDescription)
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
        showingAlert.toggle()
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
