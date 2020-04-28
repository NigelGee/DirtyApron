//
//  Information.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI

struct Information: Codable, Identifiable {
    
    struct Times: Codable {
        let day: String
        let open: Date?
        let close: Date?
        
        var formattedOpenTime: String {
            if let open = open {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return formatter.string(from: open)
            } else {
                return "Closed"
            }
        }
        
        var formattedCloseTime: String {
            if let close = close {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return formatter.string(from: close)
            } else {
                return ""
            }
        }
    }
    
    struct AddressDetails: Codable {
        let street: String
        let town: String?
        let city: String
        let zip: String
        
        var wrappedTown: String {
            if let town = town {
                return town
            } else {
                return ""
            }
        }
    }
    
    struct Coordinates: Codable {
        let latitude: Double
        let longitude: Double
        let deltaSpan: Double
    }
    
    let id: Int
    let image: String
    let name: String
    let webAddress: String
    let address: AddressDetails
    let times: [Times]
    let description: String
    let coordinates: Coordinates
    
    var wrappedImage: Image {
            if image != "" {
                return Image(decorative: image)
        } else {
            return Image(systemName: "camera")
        }
    }
}
