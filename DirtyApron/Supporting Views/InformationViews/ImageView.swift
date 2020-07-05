//
//  ImageView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    var image: Image
    
    var body: some View {
        image.resizable()
            .frame(width: 200, height: 100)
            .scaledToFill()
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 4))
            .shadow(color: .secondary, radius: 5)
            .shadow(color: .secondary, radius: 10)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(image: Image("DALogo"))
    }
}
