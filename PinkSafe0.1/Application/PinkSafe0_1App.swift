import SwiftUI

@main
struct PinkSafe0_1App: App {
    @Environment(\.openURL) var openURL
    @State private var showingCallPoliceAlert = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if url.absoluteString == "pinksafe://emergencycall" {
                        showingCallPoliceAlert = true
                    }
                }
                .alert("Ligar para a Polícia?", isPresented: $showingCallPoliceAlert) {
                    Button("Ligar 190", role: .destructive) {
                        if let url = URL(string: "tel://190") {
                            openURL(url)
                        }
                    }
                    Button("Cancelar", role: .cancel) { }
                } message: {
                    Text("Tem certeza que deseja ligar para a polícia (190)?")
                }
        }
    }
}
