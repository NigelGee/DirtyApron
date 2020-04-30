//
//  Modifiers.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI


struct TypeBadges: ViewModifier {
    var text: String
        
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .padding(4)
            .background(MenuItems.typeColors[text, default: .black])
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

struct Buttons: ViewModifier {
    var colour: Color
    
    func body(content: Content) -> some View{
        content
            .foregroundColor(.white)
            .padding(4)  
            .background(colour)
            .clipShape(Capsule())
            .padding(.top)
    }
}

extension View {
    func badgesStyle(text: String) -> some View {
        self.modifier(TypeBadges(text: text))
    }
    
    func styleButton(colour: Color) -> some View {
        self.modifier(Buttons(colour: colour))
    }
}
