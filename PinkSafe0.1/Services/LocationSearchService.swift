//
//  LocationSearchService.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

// ViewModels/LocationSearchService.swift
import SwiftUI
import MapKit
import CoreLocation

class LocationSearchService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var nearbySupportLocations: [MKMapItem] = []
    @Published var fixedSupportLocations: [MKAnnotation] = []
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager = CLLocationManager()
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        loadFixedLocations()
    }
    
    func loadFixedLocations() {
        let locations = [
            (name: "DEAM – Delegacia da Mulher (Asa Sul)", lat: -15.8122, lon: -47.8928),
            (name: "DEAM II – Ceilândia", lat: -15.8060, lon: -47.8480),
            (name: "Distrito/Área Especial – Gama (14ª DP)", lat: -15.9310, lon: -48.0890),
            (name: "Distrito/Área Especial – Paranoá (6ª DP)", lat: -15.8025, lon: -47.7845),
            (name: "31ª DP – Planaltina", lat: -15.6179, lon: -47.6487),
            (name: "17ª DP – Taguatinga", lat: -15.8450, lon: -48.1200),
            (name: "26ª DP – Samambaia", lat: -15.8380, lon: -48.1000),
            (name: "27ª DP – Recanto das Emas", lat: -15.8700, lon: -48.1500),
            (name: "10ª DP – Lago Sul", lat: -15.8120, lon: -47.8560),
            (name: "30ª DP – São Sebastião", lat: -15.8810, lon: -48.0500),
            (name: "33ª DP – Santa Maria", lat: -15.8390, lon: -48.0750),
            (name: "23ª DP – Ceilândia", lat: -15.8030, lon: -47.8430),
            (name: "Casa da Mulher Brasileira (Ceilândia)", lat: -15.8035, lon: -47.8468),
            (name: "CEAM 102 Sul (Asa Sul)", lat: -15.7930, lon: -47.8820),
            (name: "CEAM Planaltina", lat: -15.6179, lon: -47.6487),
            (name: "CEAM CIOB (Asa Norte/Sul)", lat: -15.7800, lon: -47.9000),
            (name: "Espaço Acolher – Plano Piloto", lat: -15.7935, lon: -47.8905)
        ]
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            fixedSupportLocations.append(annotation)
        }
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        searchNearbySupport(center: location.coordinate)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    func searchNearbySupport(center: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Centro de apoio à mulher, abrigo, psicologia, terapia, suporte"
        request.region = MKCoordinateRegion(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Erro durante a busca: \(error?.localizedDescription ?? "Erro desconhecido")")
                return
            }
            self.nearbySupportLocations = response.mapItems
            print("Encontrado(s) \(self.nearbySupportLocations.count) local(is) de apoio próximos.")
        }
    }
}
