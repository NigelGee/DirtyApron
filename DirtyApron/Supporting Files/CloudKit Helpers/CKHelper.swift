//
//  CKHelper.swift
//  DirtyApron
//
//  Created by Nigel Gee on 05/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

class CKHelper {
    static let database = CKContainer.default().publicCloudDatabase
 
// MARK: Delete for list Category and Items
    class func delete(index: Int, recordID: CKRecord.ID, completion: @escaping (Result<Int, Error>) -> ()) {
        database.delete(withRecordID: recordID) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(index))
                }
            }
        }
    }
    
// MARK: Notifications
    class func saveNotification(for categories: Categories) {

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
                        for category in categories.lists {
                            guard let recordID = category.recordID else { return }
                            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                            let predicate = NSPredicate(format: "owningCategory == %@", reference)
                            let subscription = CKQuerySubscription(recordType: "Items", predicate: predicate, options: .firesOnRecordCreation)
                            let subscriptionUpdate = CKQuerySubscription(recordType: "Items", predicate: predicate, options: .firesOnRecordUpdate)

                            let notification = CKSubscription.NotificationInfo()
                            notification.subtitle = "New \(category.name) Menu"
                            notification.alertBody = "There are new items to the \(category.name) Menu. Check them out 😋"
                            notification.shouldSendContentAvailable = true
                            notification.soundName = "default"
                            
                            let notificationUpdate = CKQuerySubscription.NotificationInfo()
                            notificationUpdate.subtitle = "Update \(category.name) Menu"
                            notificationUpdate.alertBody = "Check out the changes to the \(category.name) Menu. 👍🏻"
                            notificationUpdate.soundName = "default"

                            subscription.notificationInfo = notification
                            subscriptionUpdate.notificationInfo = notificationUpdate
                            
                            database.save(subscription) { (result, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            database.save(subscriptionUpdate) { (result, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
