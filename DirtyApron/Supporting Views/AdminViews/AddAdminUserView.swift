//
//  AddAdminUserView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 20/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AddAdminUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var adminUsers: AdminUsers
    @State private var name = ""
    @State private var password = ""
    @State private var allAccess = false
    @State private var showingAlert = false
    @State private var message = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $allAccess) {
                    Text("Full Access")
                }
                Section {
                    TextField("Admin User Name", text: $name)
                    
                    SecureField("Password", text: $password)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("ERROR"), message: Text(message), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Add New User", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Submit") {
                    self.saveAdminUser()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func saveAdminUser() {
        let adminUser = AdminUser(name: name, password: password, allAccess: allAccess)
        
        CKAdmin.save(adminUser: adminUser) { (result) in
            switch result {
            case .success(let adminUser):
                self.adminUsers.list.append(adminUser)
                self.presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
}

struct AddAdminUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddAdminUserView(adminUsers: AdminUsers())
    }
}
