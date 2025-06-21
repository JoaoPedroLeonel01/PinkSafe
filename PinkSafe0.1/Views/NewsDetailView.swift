import SwiftUI

struct NewsDetailView: View {
    let news: News
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    Image(news.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .background(Color.gray.opacity(0.3))

                    VStack(alignment: .leading, spacing: 16) {
                        Text(news.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(news.category.uppercased())
                                .font(.caption)
                                .fontWeight(.black)
                                .foregroundColor(Color("Principal"))
                            
                            Text("•")
                            
                            Text(news.source)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(news.date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        Text(news.description)
                            .font(.body)
                            .lineSpacing(5)
                        
                        Divider()
                        
                        if let url = URL(string: news.sourceURL) {
                            Link(destination: url) {
                                HStack {
                                    Text("Ler matéria completa")
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.up.right.square.fill")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Principal"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("Notícia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewsDetailView(news: newsData[0])
}
