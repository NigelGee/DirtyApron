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
//MARK: Category CKHelpers
    class func fetchCategories(completion: @escaping (Result<[Category], Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let position = NSSortDescriptor(key: "position", ascending: true)
        let name = NSSortDescriptor(key: "name", ascending: true)
        let query = CKQuery(recordType: "Categories", predicate: predicate)
        query.sortDescriptors = [position, name]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "isEnable", "position"]
        operation.resultsLimit = 50
        
        var newCategories = [Category]()
        
        operation.recordFetchedBlock = { record in
            var category = Category()
            category.recordID = record.recordID
            category.name = record["name"] as! String
            category.isEnable = record["isEnable"] as! Bool
            category.position = record["position"] as! Int
            newCategories.append(category)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(newCategories))
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }

//MARK: MenuItems CKHelpers
    class func fetchItems(recordID: CKRecord.ID, completion: @escaping (Result<[MenuItem], Error>) -> ()) {
        let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "owningCategory == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Items", predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["isEnable", "name", "description","foodType", "amount"]
        operation.resultsLimit = 50
        
        var newItems = [MenuItem]()
        
        operation.recordFetchedBlock = { record in
            var item = MenuItem()
            item.recordID = record.recordID
            item.isEnable = record["isEnable"] as! Bool
            item.name = record["name"] as! String
            item.description = record["description"] as! String
            item.foodType = record["foodType"] as! [String]
            item.amount = record["amount"] as! Double
            newItems.append(item)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(newItems))
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
// MARK: Notifications
    class func saveNotification(for categories: Categories) {
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
                        for category in categories.lists {
                            guard let recordID = category.recordID else { return }
                            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                            let predicate = NSPredicate(format: "owningCategory == %@", reference)
                            let subscription = CKQuerySubscription(recordType: "Items", predicate: predicate, options: .firesOnRecordCreation)
                            let subscriptionUpdate = CKQuerySubscription(recordType: "Items", predicate: predicate, options: .firesOnRecordUpdate)

                            let notification = CKSubscription.NotificationInfo()
                            notification.subtitle = "New \(category.name) Menu"
                            notification.alertBody = "There are new items to the \(category.name) Menu. Check them out 😋"
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
