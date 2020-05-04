//
//  DetailItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 03/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct DetailItemView: View {
    @State var menuItem: MenuItem
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var loading = false
    var width: CGFloat = 200
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ZStack {
                    ItemImageView(image: image, width: width)
                    
                    if loading {
                        ZStack {
                            Circle()
                                .fill(Color.secondary)
                                .frame(width: width - 2)
                            Spinner(isAnimating: loading, style: .large, color: .white)
                        }
                    }
                }
                .padding(.top)
                Button(action: {
                    print("\(self.menuItem.name) - £\(self.menuItem.amount)")
                }) {
                    Text("£\(menuItem.amount, specifier: "%.2f")")
                        .styleButton(colour: .blue, padding: 10)
                }
                .padding()
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(menuItem.foodType, id: \.self) {
                            Text($0)
                                .badgesStyle(text: $0)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                Text(menuItem.description)
                    .padding()
                Spacer()
            }
            .onAppear(perform: fetchImage)
            .navigationBarTitle(menuItem.name)
        }
        
    }
        
    func fetchImage() {
        loading.toggle()
        if let recordID = menuItem.recordID {
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        if let record = record {
                            if let asset = record["image"] as? CKAsset {
                                guard let assetURL = asset.fileURL else { return }
                                guard let imageData = NSData(contentsOf: assetURL) else { return }
                                guard let uiImage = UIImage(data: imageData as Data) else { return }
                                
                                self.image = Image(uiImage: uiImage)
                                self.loading.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DetailItemView_Previews: PreviewProvider {
    static let example = MenuItem(name: "Food Name", description: "Lorem ipsum", amount: 99.99, isEnable: true, foodType: ["GF", "VG"])
    
    static var previews: some View {
        DetailItemView(menuItem: example)
    }
}
