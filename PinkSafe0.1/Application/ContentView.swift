import SwiftUI

struct ContentView: View {
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            MapaView()
                .tabItem {
                    Label("Mapa", systemImage: "mappin.and.ellipse")
                }
                .tag(0)

            AssistenteVirtualView()
                .tabItem {
                    Label("Assistente", systemImage: "text.bubble.fill")
                }
                .tag(1)

            EmergencyContactsView()
                .tabItem {
                    Label("Rastreador", systemImage: "iphone.gen3.radiowaves.left.and.right")
                }
                .tag(2)

            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
                .tag(3)

            PerfilView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.principal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: .constant(0))
    }
}
