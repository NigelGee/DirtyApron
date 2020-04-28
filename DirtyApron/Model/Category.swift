//
//  CategoryMenu.swift
//  DirtyApron
//
//  Created by Nigel Gee on 28/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

class Categories: ObservableObject {
    @Published var lists: [Category] = []
}

struct Category: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var position: Int = 0
    var name: String = ""
    var isEnable: Bool = true
}
