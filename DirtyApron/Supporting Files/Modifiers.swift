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
            .clipShape(Capsule())
            .foregroundColor(.white)
    }
}

struct Buttons: ViewModifier {
    var colour: Color
    var padding: CGFloat
    
    func body(content: Content) -> some View{
        content
            .foregroundColor(.white)
            .padding(.vertical, padding)
            .padding(.horizontal, padding * 2)
            .background(colour)
            .clipShape(Capsule())
    }
}

struct Images: ViewModifier {
    var width: CGFloat
//    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: width)
            .scaledToFill()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct Watermark: ViewModifier {
    var text: String
    var place: Alignment
    
    func body(content: Content) -> some View {
        ZStack(alignment: place) {
            content
            
            Text(text)
                .font(.system(size: 8))
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(5)
        }
    }
}

extension View {
    func badgesStyle(text: String) -> some View {
        self.modifier(TypeBadges(text: text))
    }
    
    func styleButton(colour: Color, padding: CGFloat = 4) -> some View {
        self.modifier(Buttons(colour: colour, padding: padding))
    }
    
    func styleImage(width: CGFloat) -> some View {
        self.modifier(Images(width: width))
    }
    
    func watermarked(with text: String, in place: Alignment) -> some View {
        self.modifier(Watermark(text: text, place: place))
    }
}
