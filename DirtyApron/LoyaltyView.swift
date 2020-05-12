//
//  LoyaltyView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 06/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
enum StampState {
    case stamped, noStamp
}

struct LoyaltyView: View {
    
    @State private var earnedStamp = 0
    
    let numberStamps = 12
    let columnCount = 3
    var rowCount: Int {
       return numberStamps/columnCount
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                GridStack(rows: rowCount, columns: columnCount, content: card)
                        .padding()
                
                Spacer()
                
                Button("\(earnedStamp) Free Drink") {
                    
                }
                .disabled(earnedStamp <= numberStamps)
                .styleButton(colour: earnedStamp <= numberStamps ? .gray : .red, padding: 20)
                
                Button("Add Stamp") {
                    self.earnedStamp += 1
                }
                .styleButton(colour: .blue, padding: 20)
                .padding()
            }
            .navigationBarTitle("Loyalty Card", displayMode: .inline)
        }
    }
    
    func card(atRow row: Int, column: Int) -> some View {
        let stampState = StampState.noStamp

        return CardView(stampPart: StampPart(id: UUID(), state: stampState))
    }
    
}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView()
    }
}
