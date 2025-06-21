// Views/NewsCard.swift
// Define a aparência de um único card de notícia na lista.

import SwiftUI

struct NewsCard: View {
    let news: News
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Imagem da notícia
            Image(news.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
                .clipped()
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                // Categoria e data
                HStack {
                    Text(news.category)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color("Principal").opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(Color("Principal"))
                    
                    Spacer()
                    
                    Text(news.date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Título
                Text(news.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                // Descrição
                Text(news.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    // Este preview nos deixa visualizar o card de forma isolada
    // Pegamos a primeira notícia dos nossos dados como exemplo
    NewsCard(news: newsData[0])
        .padding()
}
