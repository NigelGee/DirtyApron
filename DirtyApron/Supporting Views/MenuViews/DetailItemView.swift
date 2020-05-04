//
//  DetailItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 03/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct DetailItemView: View {
    @State var menuItem: MenuItem
    @State private var image: Image?
    @State private var loading = false
    var width: CGFloat = 200
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ZStack {
                    ItemImageView(image: image, width: width)
                    
                    if loading {
                        ZStack {
                            Circle()
                                .fill(Color.secondary)
                                .frame(width: width - 2)
                            Spinner(isAnimating: loading, style: .large, color: .white)
                                
                        }
                    }
                }
                .padding(.top)
                Button(action: {
                    //MARK: add to basket
                }) {
                    Text("£\(menuItem.amount, specifier: "%.2f")")
                        .styleButton(colour: .blue, padding: 10)
                }
                .padding()
                
                HStack {
                    ForEach(menuItem.foodType, id: \.self) {
                        Text($0)
                            .badgesStyle(text: $0)
                    }
                }
                
                Text(menuItem.description)
                    .padding()
                Spacer()
            }
            .navigationBarTitle(menuItem.name)
        }
    }
}

struct DetailItemView_Previews: PreviewProvider {
    static let example = MenuItem(name: "Food Name", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", amount: 10, isEnable: true, foodType: ["GF", "VG"])
    
    static var previews: some View {
        DetailItemView(menuItem: example)
    }
}
