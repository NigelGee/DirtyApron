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
    
//MARK: Category CKHelper
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
        database.add(operation)
    }

//MARK: MenuItems CKHelper
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
        database.add(operation)
    }
    
    class func saveItem(menuItem: MenuItem, recordID: CKRecord.ID?, completion: @escaping (Result<MenuItem, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: "Items")
        if let recordID = recordID {
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            itemRecord["owningCategory"] = reference as CKRecordValue
            itemRecord["isEnable"] = menuItem.isEnable as CKRecordValue
            itemRecord["name"] = menuItem.name as CKRecordValue
            itemRecord["description"] = menuItem.description as CKRecordValue
            itemRecord["foodType"] = menuItem.foodType as CKRecordValue
            itemRecord["amount"] = menuItem.amount as CKRecordValue
            
            let imageURL = ImageHelper.getImageURL()
            let imageAsset = CKAsset(fileURL: imageURL)
            itemRecord["image"] = imageAsset
            
            database.save(itemRecord) { (record, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(menuItem))
                    }
                }
            }
        }
    }
    
    class func modifyItem(menuItem: MenuItem, completion: @escaping (Result<MenuItem, Error>) -> ()) {
        guard let recordID = menuItem.recordID else { return }
        
        database.fetch(withRecordID: recordID) { (itemRecord, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let itemRecord = itemRecord else { return }
                itemRecord["isEnable"] = menuItem.isEnable as CKRecordValue
                itemRecord["name"] = menuItem.name as CKRecordValue
                itemRecord["description"] = menuItem.description as CKRecordValue
                itemRecord["foodType"] = menuItem.foodType as CKRecordValue
                itemRecord["amount"] = menuItem.amount as CKRecordValue
                
                let imageURL = ImageHelper.getImageURL()
                let imageAsset = CKAsset(fileURL: imageURL)
                itemRecord["image"] = imageAsset
                
                database.save(itemRecord) { (record, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            guard let record = record else { return }
                            let recordID = record.recordID
                            guard let isEnable = record["isEnable"] as? Bool else { return }
                            guard let name = record["name"] as? String else { return }
                            guard let description = record["description"] as? String else { return }
                            guard let foodType = record["foodType"] as? [String] else { return }
                            guard let amount = record["amount"] as? Double else { return }
                            
                            let editItem = MenuItem(recordID: recordID, name: name, description: description, amount: amount, isEnable: isEnable, foodType: foodType)
                            
                            completion(.success(editItem))
                        }
                    }
                }
            }
        }
    }
// MARK: CKHelper AdminUsers
    class func saveAdminUsers(adminUser: AdminUser, completion: @escaping (Result<AdminUser, Error>) -> ()) {
        let adminRecord = CKRecord(recordType: "AdminUser")
        
        adminRecord["name"] = adminUser.name as CKRecordValue
        adminRecord["password"] = adminUser.password as CKRecordValue
        adminRecord["allAccess"] = adminUser.allAccess as CKRecordValue
        
        database.save(adminRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(adminUser))
                }
            }
        }
    }
    
    class func fetchAdminUsers(completion: @escaping (Result<[AdminUser], Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "AdminUser", predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name", "password", "allAccess"]
        operation.resultsLimit = 50
        
        var newAdminUser = [AdminUser]()
        
        operation.recordFetchedBlock = { record in
            var adminUser = AdminUser()
            adminUser.recordID = record.recordID
            adminUser.name = record["name"] as! String
            adminUser.password = record["password"] as! String
            adminUser.allAccess = record["allAccess"] as! Bool
            newAdminUser.append(adminUser)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(newAdminUser))
                }
            }
        }
        database.add(operation)
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
