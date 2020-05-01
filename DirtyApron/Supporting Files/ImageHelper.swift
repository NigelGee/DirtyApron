//
//  ImageHelper.swift
//  DirtyApron
//
//  Created by Nigel Gee on 01/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

class ImageHelper {
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getImageURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("menuimage.jpg")
    }
}
