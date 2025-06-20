import SwiftUI

struct AddContactView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (EmergencyContact) -> Void

    @State private var name = ""
    @State private var phone = ""
    @State private var relationship = ""

    var isFormValid: Bool {
        !name.isEmpty && !phone.isEmpty && !relationship.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informações do Contato")) {
                    TextField("Nome", text: $name)
                    TextField("Telefone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Parentesco (ex: Irmã, Melhor amigo)", text: $relationship)
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

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        let newContact = EmergencyContact(name: name, phone: phone, relationship: relationship)
                        onSave(newContact)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

struct EmergencyContactsView: View {
    @State private var contacts: [EmergencyContact] = [
        EmergencyContact(name: "Caue", phone: "(61) 91234-5678", relationship: "Irmão"),
        EmergencyContact(name: "João Pedro", phone: "(61) 98877-6655", relationship: "Melhor amigo")
    ]
    
    @State private var isAddingContact = false
    @State private var showingAddTagAlert = false

    private func call(phoneNumber: String) {

        let sanitizedPhone = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        guard let phoneUrl = URL(string: "tel://\(sanitizedPhone)") else { return }
        
        if UIApplication.shared.canOpenURL(phoneUrl) {
            UIApplication.shared.open(phoneUrl)
        } else {
            print("Não é possível realizar a ligação. Esta função requer um iPhone.")
        }
    }

    var body: some View {
        NavigationStack {

            List {

                Section(header: Text("Minhas Tags")) {
                    Button(action: {
                        showingAddTagAlert = true
                    }) {
                        HStack {
                            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                            Text("Adicionar Tag de Rastreamento")
                        }
                    }
                    .alert("Função em Desenvolvimento", isPresented: $showingAddTagAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("A funcionalidade para parear uma nova tag de rastreamento será adicionada em breve.")
                    }
                }

                Section(header: Text("Contatos de Emergência")) {

                    ForEach(contacts) { contact in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(contact.name)
                                    .font(.headline)
                                Spacer()
                                Text(contact.relationship)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text(contact.phone)
                                    .font(.subheadline)
                                Spacer()
                                Button(action: {
                                    call(phoneNumber: contact.phone)
                                }) {
                                    Image(systemName: "phone.fill")
                                        .font(.title2)
                                        .foregroundColor(Color.principal)
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                    
                    Button(action: {
                        isAddingContact = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Adicionar Contato de Emergência")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Contatos de Emergência")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isAddingContact) {
                AddContactView { newContact in
                    contacts.append(newContact)
                }
            }
        }
    }
}

#Preview {
    EmergencyContactsView()
}
