// Views/Main/MapaView.swift
import SwiftUI
import MapKit

struct MapaView: View {
    @State private var mapType: MKMapType = .standard
    @StateObject private var viewModel = ConsultationViewModel()
    @StateObject private var locationSearchService = LocationSearchService()
    
    @State private var selectedCategory: LocationCategory = .todos

    var body: some View {
        NavigationStack {
            ZStack {
                CustomMapView(mapType: $mapType)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    mapControls
                    Spacer()
                    filterButtonsView
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
            }
        }
    }
    
    private var mapControls: some View {
        HStack {
            NavigationLink(destination: ScheduledConsultationsView()) {
                Image(systemName: "calendar.badge.checkmark")
            }
            .buttonStyle(MapCircleButtonStyle())
            .padding(.leading)
            
            Spacer()
            
            Button(action: { mapType = mapType == .standard ? .hybrid : .standard }) {
                Image(systemName: mapType == .standard ? "map" : "map.fill")
            }
            .buttonStyle(MapCircleButtonStyle())
            .padding(.trailing)
        }
        .padding(.top, 50)
    }
    
    private var filterButtonsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(LocationCategory.allCases) { category in
                    Button(action: {
                        self.selectedCategory = category
                        locationSearchService.filterLocations(by: category)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon).font(.subheadline)
                            Text(category.rawValue).font(.caption).fontWeight(.semibold)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 10)
                    }
                    .background(self.selectedCategory == category ? Color("principal") : Color.white.opacity(0.9))
                    .foregroundColor(self.selectedCategory == category ? .white : Color("principal"))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    
    private var navigationButton: some View {
        NavigationLink(destination: PsychologistConsultationView()) {
            HStack(spacing: 12) {
                Image(systemName: "heart.text.square.fill")
                    .font(.title2)
                
                Text("Agende sua Consulta Psicológica Gratuita")
                    .fontWeight(.bold)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .background(LinearGradient(colors: [Color("principal").opacity(0.8), Color("principal")], startPoint: .top, endPoint: .bottom))
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct MapCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .foregroundColor(Color("principal"))
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(Circle())
            .shadow(radius: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
