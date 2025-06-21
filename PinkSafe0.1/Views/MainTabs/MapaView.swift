// Views/Main/MapaView.swift
import SwiftUI
import MapKit

struct MapaView: View {
    @State private var mapType: MKMapType = .standard
    @StateObject private var viewModel = ConsultationViewModel()
    @StateObject private var locationSearchService = LocationSearchService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomMapView(mapType: $mapType)
                    .ignoresSafeArea(edges: [.top])
                
                VStack {
                    mapControls
                    
                    Spacer()
                    
                    statusAndSearchResults
                    
                    navigationButton
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(viewModel)
        .environmentObject(locationSearchService)
        .onAppear {
            if locationSearchService.authorizationStatus == .notDetermined {
                locationSearchService.requestLocationAuthorization()
            } else if locationSearchService.authorizationStatus == .authorizedWhenInUse || locationSearchService.authorizationStatus == .authorizedAlways {
                locationSearchService.startUpdatingLocation()
            }
        }
    }
    
    // Subview para os controles do mapa
    private var mapControls: some View {
        HStack {
            NavigationLink(destination: ScheduledConsultationsView()) {
                Image(systemName: "calendar.badge.checkmark")
            }
            .buttonStyle(MapCircleButtonStyle())
            .padding(.leading)
            
            Spacer()
            
            Button(action: {
                mapType = mapType == .standard ? .hybrid : .standard
            }) {
                Image(systemName: mapType == .standard ? "map" : "map.fill")
            }
            .buttonStyle(MapCircleButtonStyle())
            .padding(.trailing)
        }
        .padding(.top)
    }

    // Subview para a barra de status e resultados de busca
    @ViewBuilder
    private var statusAndSearchResults: some View {
        if locationSearchService.authorizationStatus == .notDetermined {
            Button("Permitir Localização para Achar Apoio Próximo") {
                locationSearchService.requestLocationAuthorization()
            }
            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10).padding(.bottom)
        } else if locationSearchService.authorizationStatus == .denied || locationSearchService.authorizationStatus == .restricted {
            Text("Acesso à localização negado. Habilite nos Ajustes.")
                .multilineTextAlignment(.center).padding().background(Color.white.opacity(0.8))
                .cornerRadius(10).foregroundColor(.red).padding(.bottom)
        } else if !locationSearchService.nearbySupportLocations.isEmpty {
            // Removendo a exibição dos resultados de busca de localização
            /*
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(locationSearchService.nearbySupportLocations, id: \.self) {
                        item in
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Lugar Desconhecido").font(.headline)
                            Text(item.placemark.title ?? "Sem endereço").font(.subheadline)
                        }
                        .padding(12).background(Color.white.opacity(0.8)).cornerRadius(8).shadow(radius: 1).padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
            }
            */
        }
    }
    
    // Subview para o botão de navegação principal
    private var navigationButton: some View {
        NavigationLink(destination: PsychologistConsultationView()) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .font(.title2)
                Text("Agende sua Consulta Psicológica Gratuita")
                    .fontWeight(.bold)
                    .font(.title3)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(colors: [Color.principal.opacity(0.8), Color.principal], startPoint: .top, endPoint: .bottom)
            )
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

// Estilo customizado para os botões do mapa
struct MapCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


#Preview {
    MapaView()
}
