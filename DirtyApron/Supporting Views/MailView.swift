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
    @EnvironmentObject var orders: Orders
    @ObservedObject var userDetails: UserDetails
    @Environment(\.presentationMode) var presentationMode
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var mailStatus: MFMailComposeResult?
    
    var method: Bool
    var note: String
    
    var mailSubject: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let delivery = "\(method ? "Delivery for" : "Collection for")"
        let time = formatter.string(from: userDetails.user.time)
        
        let subject = "\(delivery) \(userDetails.user.name) at \(time)"
        
        return subject
    }
    
    var mailBody: String {
        let body = ""
        
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
