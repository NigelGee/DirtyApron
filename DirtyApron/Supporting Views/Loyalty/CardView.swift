//
//  CardView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 12/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var stampPart: StampPart
    
    var body: some View {
        ZStack {
            NoStampView()
                .rotation3DEffect(.degrees(stampPart.state == .noStamp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .opacity(stampPart.state == .noStamp ? 1 : 0)
            
            StampView()
                .rotation3DEffect(.degrees(stampPart.state != .noStamp ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(stampPart.state != .noStamp ? 1 : -1)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(stampPart: StampPart(id: UUID(), state: StampState.noStamp))
    }
}
