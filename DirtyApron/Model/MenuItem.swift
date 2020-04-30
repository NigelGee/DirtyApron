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
    
    static let typeShort = ["GF", "VE", "VG", "OR", "HL"]
    static let typeNames = ["Gluten Free", "Vegetarian", "Vegan", "Organic", "Halal"]
    static let typeColors: [String: Color] = ["GF": .orange, "VE": .red, "VG": .green, "OR": .blue, "HL": .purple]
}

struct MenuItem: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name = ""
    var description = ""
    var amount = 0.0
    var isEnable = true
    var foodType = [String]()
    var foodImage: URL?
}
