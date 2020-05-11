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
                    LoadingView(text: "Getting A Menu")
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
        CKHelper.fetchCategories { (results) in
            switch results {
            case .success(let newCategories):
                self.categories.lists = newCategories
                self.saveNotification()
            case .failure(let error):
                self.message = error.localizedDescription
                self.showingAlert.toggle()
            }
            self.loading.toggle()
        }
    }
    
    // MARK: Notifications
    func saveNotification() {
        let database = CKContainer.default().publicCloudDatabase

        database.fetchAllSubscriptions { subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        database.delete(withSubscriptionID: subscription.subscriptionID) { (str, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        print("Add")
                        for category in self.categories.lists {
                            guard let recordID = category.recordID else { return }
                            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                            let predicate = NSPredicate(format: "owningCategory == %@", reference)
                            let subscription = CKQuerySubscription(recordType: "Items", predicate: predicate, options: .firesOnRecordCreation)

                            let notification = CKSubscription.NotificationInfo()
                            notification.subtitle = "\(category.name)"
                            notification.alertBody = "New item in \(category.name)"
                            notification.soundName = "default"

                            subscription.notificationInfo = notification
                            
                            database.save(subscription) { (result, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } else {
                // enter error handling
                print(error!.localizedDescription)
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
