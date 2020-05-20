//
//  AdminUsers.swift
//  DirtyApron
//
//  Created by Nigel Gee on 19/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit


struct AdminUser: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String = ""
    var password: String = ""
    var allAccess: Bool = false
}

class AdminUsers: ObservableObject {
    @Published var list: [AdminUser] = []
    
}
