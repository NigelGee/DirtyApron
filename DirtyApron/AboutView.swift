//
//  AboutView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    let about: [AboutList] = Bundle.main.decode("about")
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                    NavigationLink(destination: AdminView()) {
                        Text("Admin")
                    }
                    .padding()
                
                    List {
                        ForEach(about) { about in
                            NavigationLink(destination: AboutDetailView(name: about.name, file: about.file)) {
                                Text(about.name)
                            }
                        }
                    }
                }
            .navigationBarTitle("About", displayMode: .inline)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
