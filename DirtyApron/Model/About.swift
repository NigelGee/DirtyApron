//
//  About.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

struct About: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct AboutList: Codable, Identifiable {
    let id: Int
    let name: String
    let file: String
}
