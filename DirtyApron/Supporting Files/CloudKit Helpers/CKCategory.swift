//
//  CKCategory.swift
//  DirtyApron
//
//  Created by Nigel Gee on 21/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

class CKCategory {
    static let database = CKContainer.default().publicCloudDatabase
    
    class func fetch(completion: @escaping (Result<[Category], Error>) -> ()) {
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
    
    class func save(category: Category, completion: @escaping (Result<Category, Error>) -> ()) {
        let categoryRecord = CKRecord(recordType: "Categories")
        
        categoryRecord["name"] = category.name as CKRecordValue
        categoryRecord["isEnable"] = category.isEnable as CKRecordValue
        categoryRecord["position"] = category.position as CKRecordValue
        
        let newCategory = Category(position: category.position, name: category.name, isEnable: category.isEnable)
        
        database.save(categoryRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(newCategory))
                }
            }
        }
    }
    
    class func modify(category:Category, completion: @escaping (Result<Category, Error>) -> ()) {
        guard let recordID = category.recordID else { return }
        
        database.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let record = record else { return }
                record["name"] = category.name as CKRecordValue
                record["isEnable"] = category.isEnable as CKRecordValue
                record["position"] = category.position as CKRecordValue
                
                database.save(record) { (record, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            guard let record = record else { return }
                            let recordID = record.recordID
                            guard let name = record["name"] as? String else { return }
                            guard let isEnable = record["isEnable"] as? Bool else { return }
                            guard let position = record["position"] as? Int else { return }
                            
                            let editItem = Category(recordID: recordID, position: position, name: name, isEnable: isEnable)
                            
                            completion(.success(editItem))
                        }
                    }
                }
            }
        }
    }
}
