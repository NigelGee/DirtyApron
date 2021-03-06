//
//  StringInterpolation-Number.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(format number: Double, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let result = formatter.string(from: number as NSNumber) {
            appendLiteral(result)
        }
    }
}
