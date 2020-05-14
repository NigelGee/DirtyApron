//
//  LoadingView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 06/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var text: String
    var spinner: Bool
    
    var body: some View {
        ZStack {
           
            BlurBackGroundView()
            
            VStack {
                if spinner {
                    Spinner(isAnimating: true, style: .large, color: .white)
                        .padding()
                } else {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                Text(text)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    
            }
        }
        .frame(width: 150, height: 150)
        .cornerRadius(10)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "Getting a Menu", spinner: false)
    }
}
