import Foundation

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable, Identifiable {
    let id = UUID() // Adicionado para conformidade com Identifiable
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}

class NewsService: ObservableObject {
    private let apiKey = "c9a20d5199494695963e0e397381469e" // Sua chave de API
    private let baseUrl = "https://newsapi.org/v2/everything"
    
    @Published var news: [Article] = []
    
    func fetchNews(query: String = "women empowerment OR gender equality OR women in tech", language: String = "en") async throws {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "sortBy", value: "relevancy"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData // Always fetch latest data

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Para decodificar datas no formato ISO 8601
        
        let apiResponse = try decoder.decode(NewsAPIResponse.self, from: data)
        DispatchQueue.main.async {
            self.news = apiResponse.articles
        }
    }
} 