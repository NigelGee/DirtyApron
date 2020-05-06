//
//  BlurBackGround.swift
//  DirtyApron
//
//  Created by Nigel Gee on 06/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct BlurBackGroundView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<BlurBackGroundView>) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurBackGroundView>) {
        
    }
}
