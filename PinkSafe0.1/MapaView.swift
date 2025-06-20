import SwiftUI
import MapKit
import CoreLocation // Import CoreLocation

// MARK: - Consultation and ViewModel (Existing)
struct Consultation: Identifiable {
    let id = UUID()
    let name: String
    let reason: String
    let dateTime: Date
}


class ConsultationViewModel: ObservableObject {
    @Published var scheduledConsultations: [Consultation] = []
        
    
    func schedule(name: String, reason: String, dateTime: Date) {
        let newConsultation = Consultation(name: name, reason: reason, dateTime: dateTime)
        scheduledConsultations.append(newConsultation)
        scheduledConsultations.sort { $0.dateTime < $1.dateTime }
    }
}

// MARK: - LocationSearchService (Modified)
class LocationSearchService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var nearbySupportLocations: [MKMapItem] = []
    @Published var fixedSupportLocations: [MKAnnotation] = [] // New: For fixed locations
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager = CLLocationManager()
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        loadFixedLocations() // New: Load fixed locations on init
    }
    
    // New: Function to load predefined support locations
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
        manager.stopUpdatingLocation() // Stop updating after getting a location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    func searchNearbySupport(center: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Centro de apoio à mulher, abrigo, psicologia, terapia, suporte" // Palavras-chave da busca
        
        // Corrigido: uso do center que já é parâmetro da função, e definição de uma área de 5km
        request.region = MKCoordinateRegion(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Erro durante a busca: \(error?.localizedDescription ?? "Erro desconhecido")")
                return
            }

            // Supondo que nearbySupportLocations seja uma variável de instância (ex: @State ou @Published)
            self.nearbySupportLocations = response.mapItems
            print("Encontrado(s) \(self.nearbySupportLocations.count) local(is) de apoio próximos.")
        }
    }

}

// MARK: - CustomMapView (Modified)
struct CustomMapView: UIViewRepresentable {
    @Binding var mapType: MKMapType
    @EnvironmentObject var locationSearchService: LocationSearchService // Access the service
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true // Show user's current location
        mapView.mapType = mapType
        mapView.delegate = context.coordinator // Set the delegate
        
        // New: Set initial region to Brasília
        let initialCoordinate = CLLocationCoordinate2D(latitude: -15.7942, longitude: -47.8825)
        let region = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: 30000, longitudinalMeters: 30000) // 30km zoom
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        
        // Remove existing annotations (except user location)
        uiView.removeAnnotations(uiView.annotations.filter { !($0 is MKUserLocation) })
        
        // Add annotations for fixed support locations
        uiView.addAnnotations(locationSearchService.fixedSupportLocations)
        
        // Add new annotations for nearby (searched) support locations
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
        
        // Optional: Implement delegate methods for annotation views if you want custom pins
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Do not customize the user's location annotation
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "SupportLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.markerTintColor = .systemPurple // Custom color for the pins
                annotationView?.glyphText = "♀️" // Optional: Add a symbol to the pin
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}


// MARK: - MapaView (Main View)
struct MapaView: View {
    @State private var mapType: MKMapType = .standard
    @StateObject private var viewModel = ConsultationViewModel()
    @StateObject private var locationSearchService = LocationSearchService() // New: Location Search Service
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomMapView(mapType: $mapType)
                    .ignoresSafeArea(edges: [.top])
                
                VStack {
                    HStack {
                        NavigationLink(destination: ScheduledConsultationsView()) {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.title2)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        Button(action: {
                            mapType = mapType == .standard ? .hybrid : .standard
                        }) {
                            Image(systemName: mapType == .standard ? "map" : "map.fill")
                                .font(.title2)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    // New: Display nearby locations or prompt for authorization
                    if locationSearchService.authorizationStatus == .notDetermined {
                        Button("Permitir Localização para Achar Apoio Próximo") {
                            locationSearchService.requestLocationAuthorization()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom)
                    } else if locationSearchService.authorizationStatus == .denied || locationSearchService.authorizationStatus == .restricted {
                        Text("Acesso à localização negado. Por favor, habilite nos Ajustes para encontrar locais de apoio.")
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .foregroundColor(.red)
                            .padding(.bottom)
                    } else if !locationSearchService.nearbySupportLocations.isEmpty {
                        // Display found locations (you might want a dedicated list view)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(locationSearchService.nearbySupportLocations, id: \.self) { item in
                                    VStack(alignment: .leading) {
                                        Text(item.name ?? "Lugar Desconhecido")
                                            .font(.headline)
                                        Text(item.placemark.title ?? "Sem endereço")
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .shadow(radius: 1)
                                    .padding(.horizontal, 4)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    NavigationLink(destination: PsychologistConsultationView()) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                            Text("Preciso de Suporte Emocional !")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.purple]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(viewModel)
        .environmentObject(locationSearchService)
        .onAppear {
             // Request authorization only if not already determined
            if locationSearchService.authorizationStatus == .notDetermined {
                locationSearchService.requestLocationAuthorization()
            } else if locationSearchService.authorizationStatus == .authorizedWhenInUse || locationSearchService.authorizationStatus == .authorizedAlways {
                locationSearchService.startUpdatingLocation()
            }
        }
    }
}


// MARK: - PsychologistConsultationView (Existing)
struct PsychologistConsultationView: View {
    @EnvironmentObject var viewModel: ConsultationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var contactPhone: String = ""
    @State private var email: String = ""
    @State private var reasonForConsultation: String = ""
    @State private var preferredDateTime: Date = Date()
    @State private var showingAlert = false
    
    // Assumes a Color.principal exists in your project
    let principalColor = Color.purple
    
    var isFormValid: Bool {
        !name.isEmpty && !contactPhone.isEmpty && !email.isEmpty && !reasonForConsultation.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Suas Informações")) {
                TextField("Nome Completo", text: $name)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                TextField("Telefone de Contato", text: $contactPhone)
                    .keyboardType(.phonePad)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            Section(header: Text("Detalhes da Consulta")) {
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $reasonForConsultation)
                        .frame(height: 100)
                    
                    if reasonForConsultation.isEmpty {
                        Text("Gostaria de agendar uma conversa sobre...")
                            .foregroundColor(Color(UIColor.placeholderText))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
                
                DatePicker("Data e Hora Preferenciais", selection: $preferredDateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
            }
            Button("Solicitar Consulta") {
                viewModel.schedule(
                    name: name,
                    reason: reasonForConsultation,
                    dateTime: preferredDateTime
                )
                showingAlert = true
            }
            .disabled(!isFormValid)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(isFormValid ? principalColor : Color.gray)
            .foregroundColor(.white)
            .alert("Solicitação Enviada", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Sua solicitação foi enviada com sucesso! Ela já aparece na sua lista de consultas agendadas.")
            }
        }
        .navigationTitle("Marque sua consulta")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ScheduledConsultationsView (Existing)
struct ScheduledConsultationsView: View {
    @EnvironmentObject var viewModel: ConsultationViewModel
    
    var body: some View {
        VStack {
            if viewModel.scheduledConsultations.isEmpty {
                Spacer()
                Image(systemName: "calendar.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.7))
                    .padding()
                Text("Nenhuma consulta agendada.")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Agende sua primeira consulta na tela anterior!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(viewModel.scheduledConsultations) { consultation in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(consultation.name)
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "calendar")
                            Text(consultation.dateTime, style: .date)
                            Text(consultation.dateTime, style: .time)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Text(consultation.reason)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .padding(.top, 4)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Consultas Agendadas")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Preview (Existing)
#Preview {
    MapaView()
}

// Note: You might need to define Color.principal in your assets or extensions
// extension Color {
//     static let principal = Color.purple
// }
