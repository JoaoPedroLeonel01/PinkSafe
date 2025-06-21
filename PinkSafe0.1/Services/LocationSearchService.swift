import SwiftUI
import MapKit
import CoreLocation

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
        print("\(allFixedLocations.count) locais fixos carregados em allFixedLocations.")
        filterLocations(by: .todos)
    }
    

    func filterLocations(by category: LocationCategory) {
        if category == .todos {
            filteredSupportLocations = allFixedLocations
        } else {
            filteredSupportLocations = allFixedLocations.filter { $0.category == category }
        }
        print("Filtrando por: \(category.rawValue) - \(filteredSupportLocations.count) locais encontrados.")
    }
    

    func loadFixedLocations() {
        self.allFixedLocations = LocationsDatabase.allLocations
    }
    

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
