// Views/Main/MapaView.swift
import SwiftUI
import MapKit

struct MapaView: View {
    @State private var mapType: MKMapType = .standard
    @StateObject private var viewModel = ConsultationViewModel()
    @StateObject private var locationSearchService = LocationSearchService()
    
    @State private var selectedCategory: LocationCategory = .todos
    @State private var showingFilterMenu = false

    var body: some View {
        NavigationStack {
            ZStack {
                CustomMapView(mapType: $mapType)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    mapControls
                    Spacer()
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
            locationSearchService.filterLocations(by: selectedCategory)
        }
    }
    
    private var mapControls: some View {
        HStack {
            Menu {
                ForEach(LocationCategory.allCases) { category in
                    Button(action: {
                        self.selectedCategory = category
                        locationSearchService.filterLocations(by: category)
                    }) {
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.rawValue)
                        }
                    }
                }
            } label: {
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
            }
            .buttonStyle(MapCircleButtonStyle())
            
            Spacer()
            
            Button(action: { mapType = mapType == .standard ? .hybrid : .standard }) {
                Image(systemName: mapType == .standard ? "map" : "map.fill")
            }
            .buttonStyle(MapCircleButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
    }
    
    private var navigationButton: some View {
        NavigationLink(destination: PsychologistConsultationView()) {
            HStack(spacing: 12) {
                Image(systemName: "heart.text.square.fill")
                    .font(.title2)
                
                Text("Agende sua Assistencia Emocinal")
                    .fontWeight(.bold)
                    .font(.callout)
            }
            .frame(width: 385)
            .frame(height: 65)
            .background(LinearGradient(colors: [Color("principal"), Color("principal")], startPoint: .top, endPoint: .bottom))
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
            .padding(7)
            .background(Color.white.opacity(0.9))
            .clipShape(Circle())
            .shadow(radius: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    MapaView()
}
