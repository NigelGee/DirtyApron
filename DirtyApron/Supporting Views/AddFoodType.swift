//
//  AddFoodType.swift
//  DirtyApron
//
//  Created by Nigel Gee on 30/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
// MARK: Not using a present need to see how to get pickedType to the String array
struct AddFoodType: View {@Environment(\.presentationMode) var presentationMode
    @State var menuItem: MenuItem
    @State var pickedType: [String]
    
    var body: some View {
        List {
            ForEach(0..<MenuItems.typeShort.count, id: \.self) { type in
                HStack {
                    Text(MenuItems.typeShort[type])
                        .bold()
                    Text("- \(MenuItems.typeNames[type])")
                    Spacer()
                    if self.pickedType.contains(MenuItems.typeShort[type]) {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    if !self.pickedType.contains(MenuItems.typeShort[type]) {
                        self.pickedType.append(MenuItems.typeShort[type])
                    } else {
                        for i in 0..<self.pickedType.count {
                            if MenuItems.typeShort[type] == self.pickedType[i] {
                                self.pickedType.remove(at: i)
                                break
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Add Food Types")
        .navigationBarItems(trailing: Button("Update") {
            print(self.pickedType)
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}

struct AddFoodType_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodType(menuItem: MenuItem(), pickedType: [])
    }
}
