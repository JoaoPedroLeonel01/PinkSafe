import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapaView()
                .tabItem {
                    Label("Mapa", systemImage: "mappin.and.ellipse")
                }
            
            AssistenteVirtualView()
                .tabItem {
                    Label("Assistente", systemImage: "text.bubble.fill")
                }
            
            EmergencyContactsView()
                .tabItem {
                    Label("Rastreador", systemImage: "iphone.gen3.radiowaves.left.and.right")
                }
            
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            PerfilView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
        .accentColor(.principal)
    }
}

#Preview {
    ContentView()
}
