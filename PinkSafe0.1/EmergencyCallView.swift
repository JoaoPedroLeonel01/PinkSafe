import SwiftUI

struct EmergencyCallView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Situação de Emergência")
                .font(.title)
                .bold()

            Text("Deseja ligar para a polícia?")
                .font(.headline)

            Button(action: {
                if let url = URL(string: "tel://190"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Ligar para 190")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
