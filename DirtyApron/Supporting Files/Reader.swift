//
//  Reader.swift
//  DirtyApron
//
//  Created by Nigel Gee on 13/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import CoreNFC
import UIKit


class Reader: NSObject, NFCNDEFReaderSessionDelegate, ObservableObject {
    var session: NFCNDEFReaderSession?
    
    @Published var collectedStamps = UserDefaults.standard.integer(forKey: "CollectedStamps")
    @Published var showingAlert = false
    @Published var title = ""
    @Published var message = ""
    
    var adjustedStamp: Int {
        collectedStamps % maxStamps
    }
    
    let maxStamps = 9
    
    private var isRedeemed = false
    private let addStampTag = "\u{2}enaddStampRGC"
    private let redeemDrinkTag = "\u{2}enredeemDrinkRGC"
    
    func addStamp(redeem: Bool) {
        guard NFCNDEFReaderSession.readingAvailable else {
            title = "Scanning Not Supported"
            message = "Please use a device that supports NFC"
            showingAlert = true
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
        if redeem {
            isRedeemed = true
            session?.alertMessage = "Hold your device near the \"Stamp\" to receive your free drink"
        } else {
            isRedeemed = false
            session?.alertMessage = "Hold your device near the \"Stamp\" to add"
        }
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var readerString = ""
        
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    readerString = string
                }
            }
        }
        
        if readerString == addStampTag && !isRedeemed {
            collectedStamps += 1
            UserDefaults.standard.set(self.collectedStamps, forKey: "CollectedStamps")
        } else if readerString == redeemDrinkTag && isRedeemed {
            collectedStamps -= maxStamps
            UserDefaults.standard.set(self.collectedStamps, forKey: "CollectedStamps")
        } else {
            title = "Wrong Stamp"
            message = "Please try again!"
            showingAlert = true
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Active")
    }
}

