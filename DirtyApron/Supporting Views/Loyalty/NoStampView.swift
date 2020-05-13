//
//  NoStampView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 12/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct NoStampView: View {
    var stampNumber: Int
    
    var body: some View {
        ZStack {
            Text("\(stampNumber + 1)")
                .font(.title)
                .foregroundColor(.secondary)
            
            Circle()
                .foregroundColor(.clear)
                .frame(height: 65)
                .overlay(Circle().stroke(Color.secondary, lineWidth: 4))
                .padding()
        }
    }
}

struct NoStampView_Previews: PreviewProvider {
    static var previews: some View {
        NoStampView(stampNumber: 1)
    }
}
