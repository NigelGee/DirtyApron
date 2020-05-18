//
//  MapView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var title: String
    var deltaSpan: Double
    var venueCoordinate: CLLocationCoordinate2D
    var header: Bool
    @ObservedObject var locationManager = LocationManager()
   
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {

        let span = MKCoordinateSpan(latitudeDelta: deltaSpan, longitudeDelta: deltaSpan)
        let region = MKCoordinateRegion(center: venueCoordinate, span: span)
        
        let venueLocation = MKPointAnnotation()
        venueLocation.coordinate = venueCoordinate
        venueLocation.title = title
        
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: venueCoordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        if header {
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let unwrappedResponse = response else { return }

                for route in unwrappedResponse.routes {
                    view.addOverlay(route.polyline)
                    view.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
        
        view.addAnnotation(venueLocation)
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
        
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 3
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "placemark"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
//                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(title: "Dirty Apron", deltaSpan: 0.003, venueCoordinate: MKPointAnnotation.example.coordinate, header: true)
    }
}

#if DEBUG
extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "Dirty Apron"
        annotation.subtitle = "Bring home the bacon"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.478476, longitude: -0.026857)
        return annotation
    }
}
#endif
