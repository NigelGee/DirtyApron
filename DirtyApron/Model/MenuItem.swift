//
//  MenuItem.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

class MenuItems: ObservableObject {
    @Published var lists = [MenuItem]()
    
    static let typeColors: [String: Color] = ["GF": .orange, "VE": .red, "VG": .green, "OR": .blue, "HL": .purple]
    static let typeFullName: [String: String] = ["GF": "Gluten Free", "VE": "Vegetarian", "VG": "Vegan", "OR": "Organic", "HL": "Halal"]
}

struct MenuItem: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name = ""
    var description = ""
    var amount = 0.00
    var isEnable = true
    var foodType = [String]()
    var foodImage: URL?
}
