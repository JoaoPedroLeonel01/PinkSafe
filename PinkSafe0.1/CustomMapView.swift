// Views/Components/CustomMapView.swift
import SwiftUI
import MapKit

struct CustomMapView: UIViewRepresentable {
    @Binding var mapType: MKMapType
    @EnvironmentObject var locationSearchService: LocationSearchService
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.mapType = mapType
        mapView.delegate = context.coordinator
        
        let initialCoordinate = CLLocationCoordinate2D(latitude: -15.7942, longitude: -47.8825)
        let region = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: 30000, longitudinalMeters: 30000)
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        
        uiView.removeAnnotations(uiView.annotations.filter { !($0 is MKUserLocation) })
        
        uiView.addAnnotations(locationSearchService.fixedSupportLocations)
        
        let nearbyAnnotations = locationSearchService.nearbySupportLocations.map { mapItem -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapItem.placemark.coordinate
            annotation.title = mapItem.name
            annotation.subtitle = mapItem.placemark.title
            return annotation
        }
        uiView.addAnnotations(nearbyAnnotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "SupportLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.markerTintColor = .systemPurple
                annotationView?.glyphText = "♀️"
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}
