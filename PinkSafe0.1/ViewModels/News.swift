import Foundation

struct News: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let imageURL: String
    let description: String
    let date: String

    let source: String
    let sourceURL: String
}
