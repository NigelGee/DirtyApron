//
//  MenuView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var categories: Categories
    
    @State private var message = ""
    @State private var showingAlert = false
    @State private var loading = false
    
    var body: some View {
        ZStack {
            if categories.lists.isEmpty && loading {
                withAnimation {
                    LoadingView(text: "Getting A Menu")
                }
                .animation(.easeInOut(duration: 1))
            } else {
                NavigationView {
                    List {
                        ForEach(categories.lists.filter(\.isEnable), id: \.id) { category in
                            NavigationLink(destination: ItemsView(category: category)) {
                                Text(category.name)
                            }
                        }
                    }
                    .navigationBarTitle("Menu", displayMode: .inline)
                }
            }
        }
        .onAppear(perform: loadCategories)
    }
    
    private func loadCategories() {
        loading.toggle()
        CKHelper.fetchCategories { (results) in
            switch results {
            case .success(let newCategories):
                self.categories.lists = newCategories
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
            self.loading.toggle()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
