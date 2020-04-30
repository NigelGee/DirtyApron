//
//  AboutDetailView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AboutDetailView: View {
    var name: String
    var file: String
    
    var body: some View {
        let about: [About] = Bundle.main.decode(file)
        
        return List(about) { about in
                VStack(alignment: .leading) {
                    Text(about.title)
                        .font(.subheadline)
                    Text(about.description)
                        .foregroundColor(.secondary)
                }
            }
    }
}

struct AboutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AboutDetailView(name: "Terms & Conditions", file: "terms")
    }
}
