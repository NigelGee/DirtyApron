//
//  StampView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 12/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct StampView: View {
    var body: some View {
        VStack {
            Image(decorative: "DAStamp").resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.secondary, lineWidth: 4))
                .frame(height: 65)
                .shadow(color: .secondary, radius: 5)
                .shadow(color: .secondary, radius: 20)
        }
    }
}

struct StampView_Previews: PreviewProvider {
    static var previews: some View {
        StampView()
    }
}
