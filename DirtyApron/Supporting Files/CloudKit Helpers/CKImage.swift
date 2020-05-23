//
//  CKImage.swift
//  DirtyApron
//
//  Created by Nigel Gee on 23/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

class CKImage {
    static let database = CKContainer.default().publicCloudDatabase
    
// MARK: Fetch Image for DetailView and AddMenuItemView
    class func fetch(recordID: CKRecord.ID, completion: @escaping (Result<UIImage, Error>) ->()) {
        database.fetch(withRecordID: recordID) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let record = record {
                        if let asset = record["image"] as? CKAsset {
                            guard let assetURL = asset.fileURL else { return }
                            guard let imageData = NSData(contentsOf: assetURL) else { return }
                            guard let uiImage = UIImage(data: imageData as Data) else { return }
                            
                            completion(.success(uiImage))
                        }
                    }
                }
            }
        }
    }
}
