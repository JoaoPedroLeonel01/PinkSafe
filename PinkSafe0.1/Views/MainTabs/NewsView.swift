import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    // LISTA DE CATEGORIAS FINAL E ATUALIZADA
    @State private var selectedCategory = "Todas"
    let categories = ["Todas", "Segurança", "Economia", "Política", "Direitos", "Sociedade"]
    
    @State private var selectedNews: News? = nil
    
    var filteredNews: [News] {
        if selectedCategory == "Todas" {
            return viewModel.news
        }
        return viewModel.news.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ScrollView de categorias
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            Button(category) {
                                selectedCategory = category
                            }
                            .buttonStyle(FilterButtonStyle(isSelected: selectedCategory == category))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Carregando notícias...")
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredNews) { news in
                                Button(action: {
                                    self.selectedNews = news
                                }) {
                                    NewsCard(news: news)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Notícias")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.fetchNews()
            }
            .sheet(item: $selectedNews) { newsItem in
                NewsDetailView(news: newsItem)
            }
        }
    }
}

#Preview {
    NewsView()
}
