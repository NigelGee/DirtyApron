//
//  InformationView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import MapKit

struct InformationView: View {
    let info: Information = Bundle.main.decode("information")
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    ZStack {
                        NavigationLink(destination: MapView(title: info.name, deltaSpan: 0.003, venueCoordinate: CLLocationCoordinate2D(latitude: info.coordinates.latitude, longitude: info.coordinates.longitude), header: true)) {
                            MapView(title: info.name, deltaSpan: info.coordinates.deltaSpan, venueCoordinate: CLLocationCoordinate2D(latitude: info.coordinates.latitude, longitude: info.coordinates.longitude), header: false)
                        }
                        .frame(height: 180)
                        .accessibility(label: Text("Map"))
                        .accessibility(addTraits: .isButton)
                        .watermarked(with: "Tap for directions", in: .topLeading)
                        
                        ImageView(image: info.wrappedImage)
                            .offset(y: 90)
                    }
                    .padding(.bottom, 50)
                    
                    Text(info.name)
                        .font(.system(.title, design: .serif))
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    if info.webAddress != "" {
                        NavigationLink(destination: WebView(website: info.webAddress)) {
                            Text(info.webAddress)
                                .font(.footnote)
                        }
                    }
                    
                    Group {
                        Text(info.address.street)
                        
                        Text("\(info.address.wrappedTown) \(info.address.city), \(info.address.zip)")
                            .padding(.bottom)
                        
                        Text(info.description)
                            .padding()
                        
                        Text("Opening Times")
                        
                        ForEach(info.times, id: \.day) { time in
                            HStack {
                                Text(time.day)
                                
                                Spacer()
                                
                                Text("\(time.formattedOpenTime == "Closed" ? "Closed" : "\(time.formattedOpenTime) - ")\(time.formattedCloseTime)")
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(time.day) \(time.formattedOpenTime == "Closed" ? "Closed" : "from \(time.formattedOpenTime) to \(time.formattedCloseTime)")"))
                            .padding(.horizontal)
                        }
                    }
                    .foregroundColor(.secondary)
    
                    Spacer()
                }
            }
            .navigationBarTitle("Information", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
