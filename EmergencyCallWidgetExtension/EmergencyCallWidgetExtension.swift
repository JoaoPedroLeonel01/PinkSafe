import WidgetKit
import SwiftUI

// O Provedor de Timeline continua o mesmo.
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date()) }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) { completion(SimpleEntry(date: Date())) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .never)
        completion(timeline)
    }
}

// O modelo de dados também continua o mesmo.
struct SimpleEntry: TimelineEntry {
    let date: Date
}

// **AQUI ESTÁ A MUDANÇA VISUAL**
// A View que desenha o conteúdo do widget com um novo design.
struct EmergencyCallWidgetEntryView : View {
    var entry: Provider.Entry
    var emergencyURL: URL { URL(string: "seumatchapp://ligar-policia")! }

    var body: some View {
        // O Link continua envolvendo tudo para garantir a funcionalidade de toque.
        Link(destination: emergencyURL) {
            ZStack {
                // 1. Fundo em degradê usando a sua cor principal e uma secundária.
                // Ajuste as cores conforme a identidade visual do seu app.
                LinearGradient(
                    gradient: Gradient(colors: [Color("principal"), Color.pink.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // 2. Conteúdo visual centralizado e mais elaborado.
                VStack {
                    // Ícone consistente com a sua Splash Screen.
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(radius: 5) // Sombra para dar profundidade.

                    Spacer() // Espaçador para empurrar o texto para baixo.

                    Text("EMERGÊNCIA")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Toque para ligar")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding() // Adiciona um espaçamento interno.
            }
        }
    }
}

// A definição principal do Widget (continua a mesma).
@main
struct EmergencyCallWidget: Widget {
    let kind: String = "EmergencyCallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EmergencyCallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Chamada de Emergência")
        .description("Toque para ligar rapidamente para a polícia.")
        .supportedFamilies([.systemSmall])
    }
}

// Preview para ver o novo design no Xcode.
struct EmergencyCallWidget_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyCallWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
