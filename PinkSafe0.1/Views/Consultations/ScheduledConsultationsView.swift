//
//  ScheduledConsultationsView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

// Views/Consultation/ScheduledConsultationsView.swift
import SwiftUI

struct ScheduledConsultationsView: View {
    @EnvironmentObject var viewModel: ConsultationViewModel
    
    var body: some View {
        VStack {
            if viewModel.scheduledConsultations.isEmpty {
                Spacer()
                Image(systemName: "calendar.badge.exclamationmark")
                    .resizable().scaledToFit().frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.7)).padding()
                Text("Nenhuma consulta agendada.").font(.title2).foregroundColor(.gray)
                Text("Agende sua primeira consulta na tela anterior!").font(.subheadline).foregroundColor(.gray)
                Spacer()
            } else {
                List(viewModel.scheduledConsultations) { consultation in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(consultation.name).font(.headline)
                        HStack {
                            Image(systemName: "calendar")
                            Text(consultation.dateTime, style: .date)
                            Text(consultation.dateTime, style: .time)
                        }
                        .font(.subheadline).foregroundColor(.secondary)
                        Text(consultation.reason).font(.body).lineLimit(3).padding(.top, 4)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Consultas Agendadas")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Exemplo de como visualizar com dados de teste
    let viewModel = ConsultationViewModel()
    viewModel.schedule(name: "Maria da Silva", reason: "Preciso de ajuda com ansiedade e estresse no trabalho.", dateTime: Date())
    
    return ScheduledConsultationsView()
        .environmentObject(viewModel)
}
