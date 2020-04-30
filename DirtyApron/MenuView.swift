//
//  MenuView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        Image(systemName: "doc.plaintext")
            .resizable()
            .frame(width: 100, height: 150)
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
