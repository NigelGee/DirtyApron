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
     @ObservedObject var reader = Reader()
    
    let columnCount = 2
    var rowCount: Int {
       return reader.maxStamps/columnCount
    }
    
    var freeStamps: Int {
        return reader.collectedStamps / reader.maxStamps
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                GridStack(rows: rowCount, columns: columnCount, content: card)
                        .padding()
                        .accessibilityElement(children: .ignore)
                        .accessibility(label: Text("\(reader.adjustedStamp) stamp\(reader.adjustedStamp > 1 ? "s" : "")"))
                
                
                Spacer()
                
                Button("\(freeStamps == 0 ? "No" : "\(freeStamps)") Free Drink\(freeStamps < 2 ? "" : "s")") {
                    self.reader.addStamp(redeem: true)
                }
                .disabled(reader.collectedStamps <= reader.maxStamps - 1)
                .styleButton(colour: reader.collectedStamps <= reader.maxStamps - 1 ? .gray : .yellow, padding: 10)
                
                Button(" Add   Stamp ") {
                    self.reader.addStamp(redeem: false)
                }
                .styleButton(colour: .purple, padding: 10)
                .padding()
            }
            .alert(isPresented: $reader.showingAlert) {
                Alert(title: Text(reader.title), message: Text(reader.message), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Loyalty Card", displayMode: .inline)
        }
    }
    
    func card(atRow row: Int, column: Int) -> some View {
        var stampState = StampState.noStamp
        let index = (row * columnCount) + column
        withAnimation {
            if index <= reader.adjustedStamp - 1 {
                stampState = StampState.stamped
            }
        }
        return CardView(loyaltyCard: LoyaltyCard(index: index, state: stampState))
    }
}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView()
    }
}
