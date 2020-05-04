//
//  ImageView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 03/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ItemImageView: View {
    var image: Image?
    var width: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.secondary)
                .styleImage(width: width)
                
            if image != nil {
                image!
                    .resizable()
                    .styleImage(width: width)
            } else {
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        ItemImageView(image: Image("cup"), width: 200)
    }
}
