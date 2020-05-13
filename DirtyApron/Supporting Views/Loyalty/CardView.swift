//
//  CardView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 12/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var loyaltyCard: LoyaltyCard
    
    var body: some View {
        ZStack {
            NoStampView(stampNumber: loyaltyCard.index)
                .rotation3DEffect(.degrees(loyaltyCard.state == .noStamp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .opacity(loyaltyCard.state == .noStamp ? 1 : 0)
            
            StampView()
                .rotation3DEffect(.degrees(loyaltyCard.state == .stamped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(loyaltyCard.state != .noStamp ? 1 : -1)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(loyaltyCard: LoyaltyCard(index: 1, state: StampState.noStamp))
    }
}
