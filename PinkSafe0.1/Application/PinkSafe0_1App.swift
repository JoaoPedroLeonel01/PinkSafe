import SwiftUI

@main
struct PinkSafe0_1App: App {
    @State private var selectedTab = 0
    @State private var mostrarTelaDeEmergencia = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(selectedTab: $selectedTab)
                    .sheet(isPresented: $mostrarTelaDeEmergencia) {
                        EmergencyCallView()
                    }
            }
            .onOpenURL { url in
                if url.absoluteString == "abrir://emergencia" {
                    selectedTab = 2 // Muda para a aba do Rastreador
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        mostrarTelaDeEmergencia = true
                    }
                }
            }
        }
    }
}
