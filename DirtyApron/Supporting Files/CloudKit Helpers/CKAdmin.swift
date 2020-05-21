//
//  CKAdmin.swift
//  DirtyApron
//
//  Created by Nigel Gee on 21/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

class CKAdmin {
    static let database = CKContainer.default().publicCloudDatabase
    
    class func save(adminUser: AdminUser, completion: @escaping (Result<AdminUser, Error>) -> ()) {
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
    
    class func fetch(completion: @escaping (Result<[AdminUser], Error>) -> ()) {
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
}
