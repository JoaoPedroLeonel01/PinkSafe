////
////  SafeZonesView.swift
////  PinkSafe0.1
////
////  Created by Joao pedro Leonel on 20/06/25.
////
//
//import SwiftUI
//import MapKit
//
//struct SafePlace: Identifiable {
//    let id = UUID()
//    let name: String
//    let type: SafePlaceType
//    let coordinate: CLLocationCoordinate2D
//    let address: String
//    let isOpen24h: Bool
//}
//
//enum SafePlaceType: String {
//    case police = "Delegacia da Mulher"
//    case hospital = "Hospital"
//    case pharmacy = "Farmácia"
//    case safeSpot = "Ponto Seguro"
//}
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var location: CLLocation?
//    @Published var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: -23.550520, longitude: -46.633308), // São Paulo
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        self.location = location
//        region = MKCoordinateRegion(
//            center: location.coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
//    }
//}
//
//struct SafeZonesView: View {
//    @StateObject private var locationManager = LocationManager()
//    @State private var selectedPlace: SafePlace?
//    @State private var showingPlaceDetails = false
//    @State private var selectedFilter: SafePlaceType?
//    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
//    @State private var mapStyle: MapStyle = .standard
//    
//    // Exemplo de lugares seguros (em produção, isso viria de uma API)
//    let safePlaces = [
//        SafePlace(name: "Delegacia da Mulher - Centro",
//                 type: .police,
//                 coordinate: CLLocationCoordinate2D(latitude: -23.550520, longitude: -46.633308),
//                 address: "Rua Exemplo, 123",
//                 isOpen24h: true),
//        SafePlace(name: "Hospital São Paulo",
//                 type: .hospital,
//                 coordinate: CLLocationCoordinate2D(latitude: -23.552520, longitude: -46.634308),
//                 address: "Av. Principal, 1000",
//                 isOpen24h: true),
//        SafePlace(name: "Farmácia 24h",
//                 type: .pharmacy,
//                 coordinate: CLLocationCoordinate2D(latitude: -23.551520, longitude: -46.632308),
//                 address: "Rua das Flores, 456",
//                 isOpen24h: true)
//    ]
//    
//    var filteredPlaces: [SafePlace] {
//        if let filter = selectedFilter {
//            return safePlaces.filter { $0.type == filter }
//        }
//        return safePlaces
//    }
//    
//    var body: some View {
//        ZStack {
//            Map(position: $cameraPosition) {
//                UserAnnotation()
//                
//                ForEach(filteredPlaces) { place in
//                    Annotation(place.name, coordinate: place.coordinate) {
//                        SafePlaceAnnotation(place: place) {
//                            selectedPlace = place
//                            showingPlaceDetails = true
//                        }
//                    }
//                        }
//                    }
//                }
//            }
//            .mapStyle(mapStyle)
//            .edgesIgnoringSafeArea(.all)
//            
//            // Filtros no topo
//            VStack {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        FilterButton(title: "Todos", type: nil, selectedFilter: $selectedFilter)
//                        FilterButton(title: "Delegacias", type: .police, selectedFilter: $selectedFilter)
//                        FilterButton(title: "Hospitais", type: .hospital, selectedFilter: $selectedFilter)
//                        FilterButton(title: "Farmácias", type: .pharmacy, selectedFilter: $selectedFilter)
//                    }
//                    .padding()
//                }
//                .background(Color.white)
//                .shadow(radius: 2)
//                
//                Spacer()
//                
//                // Botões de controle do mapa
//                HStack {
//                    Spacer()
//                    VStack(spacing: 10) {
//                        Button(action: {
//                            mapStyle = mapStyle == .standard ? .hybrid : .standard
//                        }) {
//                            Image(systemName: mapStyle == .standard ? "map" : "map.fill")
//                                .font(.title2)
//                                .padding()
//                                .background(Color.white)
//                                .clipShape(Circle())
//                                .shadow(radius: 2)
//                        }
//                        
//                        Button(action: {
//                            cameraPosition = .userLocation(fallback: .automatic)
//                        }) {
//                            Image(systemName: "location.fill")
//                                .font(.title2)
//                                .padding()
//                                .background(Color.white)
//                                .clipShape(Circle())
//                                .shadow(radius: 2)
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//        .sheet(isPresented: $showingPlaceDetails) {
//            if let place = selectedPlace {
//                PlaceDetailView(place: place)
//            }
//        }
//        .navigationTitle("Zonas Seguras")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct FilterButton: View {
//    let title: String
//    let type: SafePlaceType?
//    @Binding var selectedFilter: SafePlaceType?
//    
//    var body: some View {
//        Button(action: {
//            selectedFilter = type
//        }) {
//            Text(title)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//                .background(selectedFilter == type ? Color.principal : Color.gray.opacity(0.1))
//                .foregroundColor(selectedFilter == type ? .white : .black)
//                .cornerRadius(20)
//        }
//    }
//}
//
//struct PlaceDetailView: View {
//    let place: SafePlace
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading, spacing: 20) {
//                // Ícone e Nome
//                HStack {
//                    Image(systemName: place.type == .police ? "shield.fill" :
//                            place.type == .hospital ? "cross.fill" :
//                            "pills.fill")
//                        .font(.title)
//                        .foregroundColor(.principal)
//                    
//                    VStack(alignment: .leading) {
//                        Text(place.name)
//                            .font(.title2)
//                            .fontWeight(.bold)
//                        Text(place.type.rawValue)
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                // Informações
//                VStack(alignment: .leading, spacing: 15) {
//                    InfoRow(icon: "map", text: place.address)
//                    InfoRow(icon: "clock", text: place.isOpen24h ? "Aberto 24 horas" : "Horário comercial")
//                }
//                
//                Spacer()
//                
//                // Botão de navegação
//                Button(action: {
//                    // Aqui você implementará a navegação para o local
//                    let url = URL(string: "maps://?daddr=\(place.coordinate.latitude),\(place.coordinate.longitude)")
//                    if let url = url, UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url)
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: "location.fill")
//                        Text("Navegar até aqui")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.principal)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//            }
//            .padding()
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Fechar") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct InfoRow: View {
//    let icon: String
//    let text: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .foregroundColor(.principal)
//                .frame(width: 25)
//            Text(text)
//        }
//    }
//}
//
//#Preview {
//    SafeZonesView()
//} 
