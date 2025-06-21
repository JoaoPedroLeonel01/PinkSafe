// ViewModels/LocationSearchService.swift
import SwiftUI
import MapKit
import CoreLocation

// Anotação customizada para o mapa, que carrega a categoria do local.
class LocationAnnotation: MKPointAnnotation {
    let category: LocationCategory

    init(location: SupportLocation) {
        self.category = location.category
        super.init()
        self.coordinate = location.coordinate
        self.title = location.name
    }
}

class LocationSearchService: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Mantém todos os locais em uma lista privada e publica apenas a lista filtrada.
    private var allFixedLocations: [SupportLocation] = []
    @Published var filteredSupportLocations: [SupportLocation] = []
    
    @Published var authorizationStatus: CLAuthorizationStatus
    private let locationManager = CLLocationManager()
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        loadFixedLocations()
        filterLocations(by: .todos) // Exibe todos os locais por padrão ao iniciar
    }
    
    // Função que aplica o filtro na lista de locais.
    func filterLocations(by category: LocationCategory) {
        if category == .todos {
            filteredSupportLocations = allFixedLocations
        } else {
            filteredSupportLocations = allFixedLocations.filter { $0.category == category }
        }
    }
    
    // Carrega os dados do nosso novo arquivo de dados.
    func loadFixedLocations() {
        self.allFixedLocations = LocationsDatabase.allLocations
    }
    
    // Funções de localização do usuário
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
