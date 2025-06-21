import Foundation

struct Consultation: Identifiable {
    let id = UUID()
    let name: String
    let reason: String
    let dateTime: Date
}
