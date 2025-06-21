//
//  AddEmergencyContactView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

import SwiftUI

struct AddEmergencyContactView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var relationship = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informações do Contato")) {
                    TextField("Nome", text: $name)
                    TextField("Telefone", text: $phone)
                        .keyboardType(.phonePad)
                        .onChange(of: phone) {
                            phone = format(phone: phone)
                        }
                    TextField("Relacionamento (ex: Mãe, Irmã)", text: $relationship)
                }
                
                Section {
                    Button(action: saveContact) {
                        HStack {
                            Spacer()
                            Text("Salvar Contato")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty || phone.isEmpty || relationship.isEmpty)
                }
            }
            .navigationTitle("Novo Contato")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Contato Salvo", isPresented: $showingAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("O contato foi adicionado com sucesso!")
            }
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    private func saveContact() {
        let digitsOnly = phone.filter { "0"..."9" ~= $0 }
        
        let _ = EmergencyContact(
            name: name,
            phone: digitsOnly, // Salva só os números
            relationship: relationship
        )
        showingAlert = true
    }

    private func format(phone: String) -> String {
        let digitsOnly = phone.filter { "0"..."9" ~= $0 }
        let truncatedDigits = String(digitsOnly.prefix(11))
        var formattedString = ""
        var remainingDigits = truncatedDigits
        
        if remainingDigits.count > 0 {
            formattedString += "("
            let ddd = String(remainingDigits.prefix(2))
            formattedString += ddd
            remainingDigits = String(remainingDigits.dropFirst(2))
        }
        
        if remainingDigits.count > 0 {
            formattedString += ") "
            let firstPart = String(remainingDigits.prefix(5))
            formattedString += firstPart
            remainingDigits = String(remainingDigits.dropFirst(5))
        }
        
        if remainingDigits.count > 0 {
            formattedString += "-"
            let secondPart = String(remainingDigits.prefix(4))
            formattedString += secondPart
        }
        
        return formattedString
    }
}

#Preview {
    AddEmergencyContactView()
}
