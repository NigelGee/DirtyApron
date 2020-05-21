//
//  CKHelper.swift
//  DirtyApron
//
//  Created by Nigel Gee on 05/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

// MARK: Delete CKHelper
class CKHelper {
    static let database = CKContainer.default().publicCloudDatabase
    
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

// MARK: CKHelper AdminUsers
//    class func saveAdminUsers(adminUser: AdminUser, completion: @escaping (Result<AdminUser, Error>) -> ()) {
//        let adminRecord = CKRecord(recordType: "AdminUser")
//        
//        adminRecord["name"] = adminUser.name as CKRecordValue
//        adminRecord["password"] = adminUser.password as CKRecordValue
//        adminRecord["allAccess"] = adminUser.allAccess as CKRecordValue
//        
//        database.save(adminRecord) { (record, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(adminUser))
//                }
//            }
//        }
//    }
//    
//    class func fetchAdminUsers(completion: @escaping (Result<[AdminUser], Error>) -> ()) {
//        let predicate = NSPredicate(value: true)
//        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
//        let query = CKQuery(recordType: "AdminUser", predicate: predicate)
//        query.sortDescriptors = [sort]
//        
//        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = ["name", "password", "allAccess"]
//        operation.resultsLimit = 50
//        
//        var newAdminUser = [AdminUser]()
//        
//        operation.recordFetchedBlock = { record in
//            var adminUser = AdminUser()
//            adminUser.recordID = record.recordID
//            adminUser.name = record["name"] as! String
//            adminUser.password = record["password"] as! String
//            adminUser.allAccess = record["allAccess"] as! Bool
//            newAdminUser.append(adminUser)
//        }
//        
//        operation.queryCompletionBlock = { (cursor, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(newAdminUser))
//                }
//            }
//        }
//        database.add(operation)
//    }
    
    
    
    
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
