//
//  ContentView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CoreNFC

struct ContentView: View {
    @EnvironmentObject var categories: Categories
    @State private var selectedView = UserDefaults.standard.integer(forKey: "SelectedView")
    
    var body: some View {
        TabView(selection: $selectedView) {
            InformationView()
                .tabItem {
                    Image(systemName: "exclamationmark.circle")
                       .font(.system(size: 20))
                    Text("Info")
            }.tag(0)
            
            if NFCReaderSession.readingAvailable {
                LoyaltyView()
                    .tabItem {
                        Image(systemName: "circle.grid.3x3")
                            .font(.system(size: 20))
                        Text("Loyalty")
                }.tag(1)
            }

            MenuView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                        .font(.system(size: 20))
                    Text("Menu")
            }.tag(2)
            
            OrderView(user: UserDetails())
                .tabItem {
                    Image(systemName: "bag")
                        .font(.system(size: 20))
                    Text("Order")
            }.tag(3)
            
            AboutView()
                .tabItem {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                    Text("About")
            }.tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
