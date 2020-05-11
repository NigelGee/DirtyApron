//
//  MailView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 08/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @ObservedObject var orders: Orders
    @ObservedObject var userDetails: UserDetails
    @Environment(\.presentationMode) var presentationMode
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var mailStatus: MFMailComposeResult?
    
    var method: String
    var note: String
    
    var mailSubject: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let delivery = "\(method) for"
        let time = formatter.string(from: userDetails.user.time)
        
        let subject = "\(delivery) \(userDetails.user.name) at \(time)"
        
        return subject
    }
    
    var mailBody: String {
        var items = ""
        var totalAmount = 0.0
        for order in orders.list {
            items += "\n\(order.name) - \(format: order.amount, style: .currency)"
            totalAmount += order.amount
        }
        
        var wrappedStreet2: String {
            var wrapped = ""
            if userDetails.user.street2 != "" {
                wrapped = "\n\(userDetails.user.street2)"
            }
            return wrapped
        }
        
        var wrappedCity: String {
                   var wrapped = ""
                   if userDetails.user.city != "" {
                       wrapped = "\n\(userDetails.user.city)"
                   }
                   return wrapped
               }
        
        var addressDetails = ""
        if method == "Delivery" {
            addressDetails = "\nDelivery Address:-\n\(userDetails.user.street1)\(wrappedStreet2)\(wrappedCity)\n\(userDetails.user.zip)\n"
        }
        
        let body = "My order for:-\n\(items)\n\nTotal Amount: \(format: totalAmount, style: .currency)\n\(addressDetails)\(note)\nPay on \(method)"
        return body
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentationMode: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        @Binding var mailStatus: MFMailComposeResult?
        
        init(presentationMode: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>, mailStatus: Binding<MFMailComposeResult?>) {
            _presentationMode = presentationMode
            _result = result
            _mailStatus = mailStatus
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentationMode.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                print(error!.localizedDescription)
                return
            }
            self.result = .success(result)
            self.mailStatus = result
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, result: $result, mailStatus: $mailStatus)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        
        mailVC.setToRecipients(["nigel.gee@icloud.com"])
        mailVC.setSubject(mailSubject)
        mailVC.setMessageBody(mailBody, isHTML: false)
        mailVC.mailComposeDelegate = context.coordinator
        
        return mailVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}
