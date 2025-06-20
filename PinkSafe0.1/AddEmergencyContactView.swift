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
        }
    }
    
    private func saveContact() {
        let _ = EmergencyContact(
            name: name,
            phone: phone,
            relationship: relationship
        )
        showingAlert = true
    }
}

#Preview {
    AddEmergencyContactView()
} 
