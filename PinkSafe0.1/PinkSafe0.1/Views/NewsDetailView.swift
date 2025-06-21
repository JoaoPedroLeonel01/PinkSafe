//
//  NewsDetailView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 21/06/25.
//

// Views/NewsDetailView.swift
// Mostra o conteúdo completo de uma única notícia.

import SwiftUI

struct NewsDetailView: View {
    // A notícia que será exibida
    let news: News
    
    // Variável de ambiente para fechar a sheet
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Imagem da notícia em destaque
                    Image(news.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                    
                    // Conteúdo dentro de um padding
                    VStack(alignment: .leading, spacing: 12) {
                        // Título
                        Text(news.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Categoria e Data
                        HStack {
                            Text(news.category)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color("Principal").opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(Color("Principal"))
                            
                            Spacer()
                            
                            Text(news.date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Divisor
                        Divider()
                        
                        // Descrição completa
                        Text(news.description)
                            .font(.body)
                            .lineSpacing(5) // Melhora a legibilidade de textos longos
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("Detalhes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Botão para fechar a sheet manualmente
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    // Preview para a tela de detalhe com a primeira notícia
    NewsDetailView(news: newsData[0])
}
