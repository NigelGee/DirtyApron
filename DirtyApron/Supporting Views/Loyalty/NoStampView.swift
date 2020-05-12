//
//  NoStampView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 12/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct NoStampView: View {
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(.clear)
                .frame(height: 70)
                .overlay(Circle().stroke(Color.secondary, lineWidth: 4))
                .padding()
        }
    }
}

struct NoStampView_Previews: PreviewProvider {
    static var previews: some View {
        NoStampView()
    }
}
