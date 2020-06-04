//
//  Order.swift
//  DirtyApron
//
//  Created by Nigel Gee on 07/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

class Orders: ObservableObject {
    @Published var list: [Order] = []
    
    static let methods = ["Delivery", "Collection"]
}

struct Order: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
}
