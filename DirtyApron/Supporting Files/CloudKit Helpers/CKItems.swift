//
//  CKItems.swift
//  DirtyApron
//
//  Created by Nigel Gee on 21/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

class CKItems {
    static let database = CKContainer.default().publicCloudDatabase
    
    class func fetch(recordID: CKRecord.ID, completion: @escaping (Result<[MenuItem], Error>) -> ()) {
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
    
    class func save(menuItem: MenuItem, recordID: CKRecord.ID?, completion: @escaping (Result<MenuItem, Error>) -> ()) {
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
    
    class func modify(menuItem: MenuItem, completion: @escaping (Result<MenuItem, Error>) -> ()) {
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
}
