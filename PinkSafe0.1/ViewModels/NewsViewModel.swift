//
//  NewsViewModel.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 21/06/25.
//

// ViewModels/NewsViewModel.swift
// Responsável pela lógica de buscar e gerenciar os dados das notícias.

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var news: [News] = []
    @Published var isLoading = true
    
    // Função que simula a busca de dados na rede
    func fetchNews() {
        isLoading = true
        // Simula um atraso de 1 segundo para parecer uma chamada de API real
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.news = newsData
            self.isLoading = false
        }
    }
}
