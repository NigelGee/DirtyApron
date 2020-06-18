//
//  AdaptingStack.swift
//  DirtyApron
//
//  Created by Nigel Gee on 16/06/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AdaptingStack<Content>: View where Content: View {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var content: () -> Content
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        switch sizeCategory {
        case .accessibilityMedium,
             .accessibilityLarge,
             .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraExtraExtraLarge:
            return AnyView(VStack(alignment: .leading, content: self.content).padding(.top, 10))
        default:
            return AnyView(HStack(content: self.content))
        }
    }
}
