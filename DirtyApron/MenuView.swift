//
//  MenuView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct MenuView: View {
    @EnvironmentObject var categories: Categories
    @EnvironmentObject var orders: Orders
    
    @State private var message = ""
    @State private var showingAlert = false
    @State private var loading = false
    
    @State private var subscriptionID = [CKSubscription.ID]()
    
    var body: some View {
        ZStack {
            if categories.lists.isEmpty && loading {
                withAnimation {
                    LoadingView(text: "Getting A Menu", spinner: true)
                }
                .animation(.easeInOut(duration: 1))
            } else {
                NavigationView {
                    List {
                        ForEach(categories.lists.filter(\.isEnable), id: \.id) { category in
                            NavigationLink(destination: ItemsView(category: category)) {
                                Text(category.name)
                                    .font(.headline)
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
        CKCategory.fetch { (results) in
            switch results {
            case .success(let newCategories):
                self.categories.lists = newCategories
                CKHelper.saveNotification(for: self.categories)
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
