//
//  ItemsView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 03/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ItemsView: View {
    var category: Category!
    
    var body: some View {

        List {
            Text("Menu Items")
        }
        .navigationBarTitle(category.name)
        .navigationBarItems(trailing: Button(action: {
            
        }) {
            Text("Basket")
        })
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
