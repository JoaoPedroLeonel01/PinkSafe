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
        
        // Removendo a região inicial fixa para que o mapa se ajuste automaticamente às anotações
        // let initialCoordinate = CLLocationCoordinate2D(latitude: -15.7942, longitude: -47.8825)
        // let region = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: 40000, longitudinalMeters: 40000)
        // mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        uiView.removeAnnotations(uiView.annotations.filter { !($0 is MKUserLocation) })
        
        let annotations = locationSearchService.filteredSupportLocations.map { location in
            LocationAnnotation(location: location)
        }
        uiView.addAnnotations(annotations)
        
        // Ajustar a região do mapa para mostrar todas as anotações, exceto a localização do usuário
        if !annotations.isEmpty {
            uiView.showAnnotations(annotations, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) { self.parent = parent }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let locationAnnotation = annotation as? LocationAnnotation else { return nil }
            
            let identifier = "SupportLocation"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            
            view?.canShowCallout = true
            view?.glyphImage = UIImage(systemName: locationAnnotation.category.icon)
            // Usa a cor da categoria para o pino
            view?.markerTintColor = UIColor(locationAnnotation.category.color)
            
            return view
        }
    }
} 