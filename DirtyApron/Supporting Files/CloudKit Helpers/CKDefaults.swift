//
//  CKDefaults.swift
//  DirtyApron
//
//  Created by Nigel Gee on 18/06/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

final class CKDefaults {
    static let shared = CKDefaults()
    private var ignoreLocalChanges = false
    
    private init() { }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        NotificationCenter.default.addObserver(forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default, queue: .main, using: updateLocal)
        
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main, using: updateRemote)
    }
    
    private func updateRemote(note: Notification) {
        guard ignoreLocalChanges == false else { return }
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            guard key.hasPrefix("sync-") else { continue }
            print("Updating remote value of \(key) to \(value)")
            NSUbiquitousKeyValueStore.default.set(value, forKey: key)
        }
    }
    
    private func updateLocal(note: Notification) {
        ignoreLocalChanges = true
        
        for (key, value) in NSUbiquitousKeyValueStore.default.dictionaryRepresentation {
            guard key.hasPrefix("sync-") else { continue }
            print("Updating remote value of \(key) to \(value)")
            UserDefaults.standard.set(value, forKey: key)
        }
        
        ignoreLocalChanges = false
    }
}
