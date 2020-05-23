//
//  AdminUserView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 20/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AdminUserView: View {
    @State private var showingAddAdmin = false
    @State private var showingAlert = false
    @State private var message = ""
    
    @ObservedObject var adminUsers: AdminUsers
    
    var body: some View {
        List {
            ForEach(adminUsers.list, id: \.id) { user in
                HStack {
                    Text(user.name)
                    Spacer()
                    Text("\(user.allAccess ? "Full" : "Menu")")
                }
            }
            .onDelete(perform: delete)
        }
        .sheet(isPresented: $showingAddAdmin) {
            AddAdminUserView(adminUsers: self.adminUsers)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("ERROR"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Admin Users")
        .navigationBarItems(trailing: Button(action: {
            self.showingAddAdmin.toggle()
        }){
            Image(systemName: "plus")
        })
    }
    
    private func delete(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let recordID = adminUsers.list[index].recordID else { return }
        
        CKHelper.delete(index: index, recordID: recordID) { (result) in
            switch result {
            case .success(let index):
                self.adminUsers.list.remove(at: index)
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
        }
    }
}

struct AdminUserView_Previews: PreviewProvider {
    static var previews: some View {
        AdminUserView(adminUsers: AdminUsers())
    }
}
