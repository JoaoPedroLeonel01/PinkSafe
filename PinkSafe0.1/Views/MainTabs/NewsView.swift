//
//  NewsView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

import SwiftUI

struct News: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let imageURL: String
    let description: String
    let date: String
}

struct NewsView: View {
    @State private var selectedCategory = "Todas"
    let categories = ["Todas", "Esportes", "Política", "Cultura", "Saúde", "Carreira"]
    
    let sampleNews = [
        News(title: "Marta é eleita melhor jogadora do mundo pela 7ª vez",
             category: "Esportes",
             imageURL: "marta_image",
             description: "A jogadora brasileira Marta faz história novamente no futebol feminino...",
             date: "25 Mar 2024"),
        News(title: "Número de mulheres no Congresso atinge recorde histórico",
             category: "Política",
             imageURL: "congress_image",
             description: "Representatividade feminina na política brasileira aumenta significativamente...",
             date: "24 Mar 2024"),
        // Adicione mais notícias aqui
    ]
    
    var filteredNews: [News] {
        if selectedCategory == "Todas" {
            return sampleNews
        }
        return sampleNews.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Categorias horizontais
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == category ? Color.principal : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }
                
                // Lista de notícias
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredNews) { news in
                            NewsCard(news: news)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Notícias para Mulheres")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct NewsCard: View {
    let news: News
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Imagem da notícia (placeholder por enquanto)
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                // Categoria e data
                HStack {
                    Text(news.category)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.principal.opacity(0.2))
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    Text(news.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Título
                Text(news.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                // Descrição
                Text(news.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    NewsView()
} 
