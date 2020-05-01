//
//  AddMenuItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct AddMenuItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var menuItems: MenuItems
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State var menuItem: MenuItem
    @State var height: CGFloat = 0
    @State var amount: String
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    @State private var type = ""
    @State private var title = ""
    @State private var message = ""
    var category: Category
    var isEdit: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Toggle(isOn: $menuItem.isEnable) {
                            Text("Enable")
                        }
                    }
                    
                    Section(header: Text("Details of Item")) {
                        TextField("Enter Name", text: $menuItem.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Enter Description", text: $menuItem.description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("GF, VE, VG, OR, HL", text: $type)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") {
                                self.menuItem.foodType.append(self.type.uppercased())
                                self.type = ""
                            }
                            .styleButton(colour: type == "" ? .gray : .blue)
                            .disabled(type == "")
                        }
                        
                        HStack {
                            ForEach(menuItem.foodType, id: \.self) { type in
                                Text(type)
                                    .badgesStyle(text: type)
                            }
                        }
                        
                        TextField("Amount", text: $amount)
//                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingImagePicker = true
                    }){
                        Image(systemName: "photo")
                            .font(.title)
                    }
                    .styleButton(colour: .green, padding: 7)
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$inputImage)
                    }
                    Spacer()
                    Button(action: {
                        print("Take")
                        // Action to take picture
                    }){
                        Image(systemName: "camera")
                            .font(.title)
                    }
                    .styleButton(colour: .red, padding: 7)
                    Spacer()
                }
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
                .frame(height: 200)
                .padding()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
            }
            
            .navigationBarTitle("\(isEdit ? "Edit" : "Add") \(category.name) item", displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing:
                    Button("Submit") {
                        if self.isEdit {
                            self.modifyItem()
                        } else {
                            self.saveItem()
                        }
                    }
                    .padding()
                    .disabled(menuItem.name == "")
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    //MARK: Load Image
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        let imageData:Data = inputImage.jpegData(compressionQuality: 1.0)!
        let imageURL = ImageHelper.getImageURL()
        do {
            try imageData.write(to: imageURL, options: .atomic)
        } catch {
            print("Error loading Image")
        }
    }
    
    //MARK: Save Menu Item
    func saveItem() {
        if let actualAmount = Double(self.amount) {
            let itemRecord = CKRecord(recordType: "Items")
            let item = MenuItem(name: menuItem.name, description: menuItem.description, amount: actualAmount, isEnable: menuItem.isEnable, foodType: menuItem.foodType)
            if let recordID = category.recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                itemRecord["owningCategory"] = reference as CKRecordValue
                itemRecord["isEnable"] = menuItem.isEnable as CKRecordValue
                itemRecord["name"] = menuItem.name as CKRecordValue
                itemRecord["description"] = menuItem.description as CKRecordValue
                itemRecord["foodType"] = menuItem.foodType as CKRecordValue
                itemRecord["amount"] = actualAmount as CKRecordValue
 //MARK: TODO: Error when saving Image Asset
                let imageURL = ImageHelper.getImageURL()
                let imageAsset = CKAsset(fileURL: imageURL)
                itemRecord["image"] = imageAsset
                
                CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            self.menuItems.lists.append(item)
                        }
                    }
                }
            }
            presentationMode.wrappedValue.dismiss()
        } else {
            title = "Incorrect Amount!"
            message = "You must enter a valid amount"
            showingAlert.toggle()
        }
    }
    //MARK: Modify Menu Item
    func modifyItem() {
        if let actualAmount = Double(amount) {
            guard let recordID = menuItem.recordID else { return }
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (itemRecord, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let itemRecord = itemRecord else { return }
                    itemRecord["isEnable"] = self.menuItem.isEnable as CKRecordValue
                    itemRecord["name"] = self.menuItem.name as CKRecordValue
                    itemRecord["description"] = self.menuItem.description as CKRecordValue
                    itemRecord["foodType"] = self.menuItem.foodType as CKRecordValue
                    itemRecord["amount"] = actualAmount as CKRecordValue
                    
                    CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            guard let record = record else { return }
                            let recordID = record.recordID
                            guard let isEnable = record["isEnable"] as? Bool else { return }
                            guard let name = record["name"] as? String else { return }
                            guard let description = record["description"] as? String else { return }
                            guard let foodType = record["foodType"] as? [String] else { return }
                            guard let amount = record["amount"] as? Double else { return }
                            
                            let editItem = MenuItem(recordID: recordID, name: name, description: description, amount: amount, isEnable: isEnable, foodType: foodType)
                            
                            DispatchQueue.main.async {
                                for i in 0..<self.menuItems.lists.count {
                                    let currentItem = self.menuItems.lists[i]
                                    if currentItem.recordID == editItem.recordID {
                                        self.menuItems.lists[i] = editItem
                                    }
                                }
                            }
                        }
                    }
                }
            }
            presentationMode.wrappedValue.dismiss()
        } else {
            title = "Incorrect Amount!"
            message = "You must enter a valid amount"
            showingAlert.toggle()
        }
    }
}

struct AddMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuItemView(menuItems: MenuItems(), menuItem: MenuItem(), amount: "", category: Category(), isEdit: false)
    }
}
