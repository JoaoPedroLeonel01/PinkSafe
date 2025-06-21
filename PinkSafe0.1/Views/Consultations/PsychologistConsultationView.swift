//
//  PsychologistConsultationView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

// Views/Consultation/PsychologistConsultationView.swift
import SwiftUI

struct PsychologistConsultationView: View {
    @EnvironmentObject var viewModel: ConsultationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var contactPhone: String = ""
    @State private var email: String = ""
    @State private var reasonForConsultation: String = ""
    @State private var preferredDateTime: Date = Date()
    @State private var showingAlert = false
    
    let principalColor = Color("principal")
    
    var isFormValid: Bool {
        !name.isEmpty && !contactPhone.isEmpty && !email.isEmpty && !reasonForConsultation.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Suas Informações")) {
                TextField("Nome Completo", text: $name)
                TextField("Telefone de Contato", text: $contactPhone).keyboardType(.phonePad)
                TextField("Email", text: $email).keyboardType(.emailAddress)
            }
            
            Section(header: Text("Detalhes da Consulta")) {
                TextEditor(text: $reasonForConsultation)
                    .frame(height: 100)
                DatePicker("Data e Hora Preferenciais", selection: $preferredDateTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
            }
            
            Button("Solicitar Consulta") {
                viewModel.schedule(name: name, reason: reasonForConsultation, dateTime: preferredDateTime)
                showingAlert = true
            }
            .disabled(!isFormValid)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(isFormValid ? principalColor : Color.gray)
            .foregroundColor(.white)
            
            Section(header: Text("Minhas Consultas Agendadas")) {
                ConsultationCalendarView()
            }
        }
        .navigationTitle("Marque sua consulta")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Solicitação Enviada", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
                // Removido: presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Sua solicitação foi enviada com sucesso!")
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

#Preview {
    PsychologistConsultationView()
        .environmentObject(ConsultationViewModel())
}
