//
//  DetailItemView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 03/05/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct DetailItemView: View {
    @EnvironmentObject var orders: Orders
    @State var menuItem: MenuItem
    @State private var detailOrder: [Order] = []
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var added = false
    @State private var message = ""
    @State private var showingAlert = false
    var width: CGFloat = 200
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    // Image load
                    ZStack {
                        
                        ItemImageView(image: image, width: width)
                        
                        if image == nil {
                            ZStack {
                                Circle()
                                    .fill(Color.secondary)
                                    .frame(width: width - 2)
                                Spinner(isAnimating: true, style: .large, color: .white)
                            }
                        }
                    }
                    .padding(.top)
                    
                    Button(action: {
                        let item = Order(name: self.menuItem.name, amount: self.menuItem.amount)
                        self.detailOrder.append(item)
                        self.added.toggle()
                    }) {
                        if menuItem.amount == 0 {
                            Text("Information")
                                .styleButton(colour: .secondary, padding: 10)
                        } else {
                            Text("£\(menuItem.amount, specifier: "%.2f")")
                                .styleButton(colour: .blue, padding: 10)
                        }
                    }
                    .disabled(menuItem.amount == 0)
                    .padding()
                    // food types and description
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(menuItem.foodType.sorted(), id: \.self) { type in
                                Text(MenuItems.typeFullName[type, default: type])
                                    .badgesStyle(text: type)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Text(menuItem.description)
                            .padding()
                    }
                    
                    Spacer()
                }
                // added notification
                if added {
                    withAnimation {
                        VStack {
                            Spacer()
                            LoadingView(text: "Added...", spinner: false)
                        }
                    }
                    .animation(.easeOut, value: 1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.added.toggle()
                        }
                    }
                }
            }
        }
        .onAppear(perform: fetchImage)
        .onDisappear { self.orders.list.append(contentsOf: self.detailOrder) }
        .navigationBarTitle(menuItem.name)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("ERROR!"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .navigationBarItems(
            trailing:
            ZStack {
                Text("\(orders.list.count + detailOrder.count)")
                    .font(.callout)
                    .offset(x: 0, y: 4)

                Image(systemName: "bag")
                    .font(.title)
            }
        )
    }
    //MARK: Fetch Image
    func fetchImage() {
        if let recordID = menuItem.recordID {
            CKImage.fetch(recordID: recordID) { (result) in
                switch result {
                case .success(let uiImage):
                    self.image = Image(uiImage: uiImage)
                case .failure(let error):
                    self.message = error.localizedDescription
                    self.showingAlert.toggle()
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
