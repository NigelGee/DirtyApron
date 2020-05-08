//
//  CheckoutView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 07/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import MessageUI

struct CheckoutView: View {
    @ObservedObject var orders: Orders
    @ObservedObject var userDetails: UserDetails
    @Environment(\.presentationMode) var presentationMode
    
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var mailStatus: MFMailComposeResult? = nil
    @State private var delivery = false
    @State private var isShowingMailView = false
    @State private var note = ""
    @State private var message = ""
    @State private var showingAlert = false
    @State private var height: CGFloat = 0
    @State private var value: CGFloat = 0
    
    var isDisable: Bool {
        if delivery {
            if userDetails.user.name == "" || userDetails.user.street1 == "" || userDetails.user.zip == "" {
                return true
            }
        } else {
            if userDetails.user.name == "" {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        if mailStatus != nil {
            DispatchQueue.main.async {
                switch self.mailStatus {
                case .sent:
                    self.orders.list.removeAll()
                case .cancelled:
                    self.showingAlert.toggle()
                    self.message = "Please confirm your order"
                case .saved:
                    self.showingAlert.toggle()
                    self.message = "Please check your draft inbox"
                case .failed:
                    self.showingAlert.toggle()
                    self.message = "Ops. Something went wrong. Please try again"
                default:
                    self.showingAlert.toggle()
                    self.message = "Unknown Error"
                }
                if self.orders.list.isEmpty {
                    self.presentationMode.wrappedValue.dismiss()
                }
                self.mailStatus = nil
            }
        }
        
        return NavigationView {
            Form {
                Toggle(isOn: $delivery) {
                    Text("Delivery")
                }
                
                DatePicker(selection: $userDetails.user.time, displayedComponents: .hourAndMinute) {
                    Text("Time of \(delivery ? "Delivery" : "Collection")")
                }
                
                Section(header: Text("Name")) {
                    TextField("Enter Name", text: $userDetails.user.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                
                    if delivery {
                        Group {
                            TextField("Street", text: $userDetails.user.street1)
                            TextField("", text: $userDetails.user.street2)
                            TextField("City", text: $userDetails.user.city)
                            TextField("Postcode", text: $userDetails.user.zip)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("Additional Notes")) {
                    ResizableTextField(title: "Enter Additional Notes", text: $note, height: $height)
                }
                if MFMailComposeViewController.canSendMail() {
                    Button("Submit"){
                        self.checkout()
                    }
                    .disabled(isDisable)
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(userDetails: self.userDetails, result: self.$result, mailStatus: self.$mailStatus, method: self.delivery, note: self.note)
                    }
                } else {
                    Text("Device not configured to send Email for confirmation")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear(perform: onLoad)
            .offset(y: -self.value)
//            .navigationBarItems(
//                trailing:
//                    Button("Dismiss") {
//                        self.presentationMode.wrappedValue.dismiss()
//                    }
//            )
        }
    }
    
    func checkout() {
        UIApplication.shared.endEditing()
//        self.presentationMode.wrappedValue.dismiss()
        isShowingMailView = true
    }
    
    func onLoad() {
        userDetails.user.time  = Calendar.current.date(byAdding: .minute, value: 10, to: Date()) ?? Date()
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { key in
            let value = key.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.value = value.height - 50
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { key in
            self.value = 0
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orders: Orders(), userDetails: UserDetails())
    }
}
