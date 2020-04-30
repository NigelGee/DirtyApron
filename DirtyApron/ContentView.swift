//
//  ContentView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            InformationView()
                .tabItem {
                    Image(systemName: "exclamationmark.circle")
                    Text("Info")
                }
            
            MenuView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Menu")
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
