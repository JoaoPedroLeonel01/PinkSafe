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
    var selectedDate: Date?
    
    var filteredConsultations: [Consultation] {
        if let date = selectedDate {
            return viewModel.scheduledConsultations.filter {
                Calendar.current.isDate($0.dateTime, inSameDayAs: date)
            }
        } else {
            return viewModel.scheduledConsultations
        }
    }
    
    var body: some View {
        VStack {
            if filteredConsultations.isEmpty {
                Spacer()
                Image(systemName: "calendar.badge.exclamationmark")
                    .resizable().scaledToFit().frame(width: 80, height: 80)
                    .foregroundColor(.gray.opacity(0.7)).padding()
                Text("Nenhuma consulta agendada para este dia.").font(.title2).foregroundColor(.gray)
                Text("Agende sua primeira consulta na tela de agendamento!").font(.subheadline).foregroundColor(.gray)
                Spacer()
            } else {
                List(filteredConsultations) { consultation in
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
        .navigationTitle(selectedDate == nil ? "Todas as Consultas" : "Consultas em \(formattedDate(selectedDate!))")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}

#Preview {
    let viewModel = ConsultationViewModel()
    let futureDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
    
    viewModel.schedule(name: "Maria da Silva", reason: "Preciso de ajuda com ansiedade e estresse no trabalho.", dateTime: Date())
    viewModel.schedule(name: "Ana Paula", reason: "Dificuldade em lidar com situações de estresse.", dateTime: futureDate)
    
    return Group {
        ScheduledConsultationsView()
            .environmentObject(viewModel)
        ScheduledConsultationsView(selectedDate: Date())
            .environmentObject(viewModel)
        ScheduledConsultationsView(selectedDate: futureDate)
            .environmentObject(viewModel)
    }
}
