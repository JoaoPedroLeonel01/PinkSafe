//
//  PerfilView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

import SwiftUI

struct UserProfile {
    var name: String
    var email: String
    var phone: String
}

struct PerfilView: View {
    @State private var userProfile = UserProfile(
        name: "Maria Silva",
        email: "mariasilva@gmail.com",
        phone: "(61) 98765-4321"
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Header Profile Section
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.principal)
                        
                        Text(userProfile.name)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 20)
                    
                    // Informações Pessoais
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Informações Pessoais")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        NavigationLink {
                            PersonalInfoView(userProfile: $userProfile)
                        } label: {
                            HStack {
                                Image(systemName: "person.text.rectangle")
                                Text("Editar Informações")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Contatos de Emergência
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Segurança")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        NavigationLink {
                            EmergencyContactsView()
                        } label: {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Contatos de Emergência")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Configurações da Conta
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Configurações da Conta")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Button(action: {
                            // Ação para sair
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sair da Conta")
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Ação para deletar conta
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Deletar Conta")
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Meu Perfil")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
struct PersonalInfoView: View {
    @Binding var userProfile: UserProfile
    
    var body: some View {
        Form {
            Section(header: Text("Informações Básicas")) {
                HStack {
                    Text("Nome")
                    Spacer()
                    Text(userProfile.name)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("E-mail")
                    Spacer()
                    Text(userProfile.email)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Telefone")
                    Spacer()
                    Text(userProfile.phone)
                        .foregroundColor(.gray)
                }
            }
            
            Section {
                Button("Editar Informações") {
                    // Ação para editar
                }
                .foregroundColor(.principal)
            }
        }
        .navigationTitle("Minhas Informações")
        .navigationBarTitleDisplayMode(.large)
    }
}


#Preview {
    PerfilView()
} 
