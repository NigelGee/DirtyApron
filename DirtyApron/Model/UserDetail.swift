//
//  UserDetail.swift
//  DirtyApron
//
//  Created by Nigel Gee on 07/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

struct UserDetail: Identifiable, Codable {
    var id = UUID()
    var name: String
    var time: Date
    var phone: String
    var street1: String
    var street2: String
    var city: String
    var zip: String
}


class UserDetails: ObservableObject {
    @Published var user: UserDetail {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                UserDefaults.standard.set(encoded, forKey: "sync-UserDetails")
            }
        }
    }
    
    init() {
        if let users = UserDefaults.standard.data(forKey: "sync-UserDetails") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(UserDetail.self, from: users) {
                self.user = decoded
                return
            }
        }
        self.user = UserDetail(name: "", time: Date(), phone: "", street1: "", street2: "", city: "", zip: "")
    }
}

