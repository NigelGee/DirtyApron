//
//  ContentView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @EnvironmentObject var categories: Categories
    
    var body: some View {
        TabView {
//            InformationView()
//                .tabItem {
//                    Image(systemName: "exclamationmark.circle")
//                    Text("Info")
//                }
    
//            LoyaltyView()
//                .tabItem {
//                    Image(systemName: "circle.grid.3x3")
//                    Text("Loyalty")
//            }

            MenuView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Menu")
            }
            

            OrderView(user: UserDetails())
                .tabItem {
                    Image(systemName: "bag")
                    Text("Order")
            }
            
            AboutView()
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("About")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
