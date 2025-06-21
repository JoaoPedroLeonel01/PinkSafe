import SwiftUI

class ConsultationViewModel: ObservableObject {
    @Published var scheduledConsultations: [Consultation] = []
    
    func schedule(name: String, reason: String, dateTime: Date) {
        let newConsultation = Consultation(name: name, reason: reason, dateTime: dateTime)
        scheduledConsultations.append(newConsultation)
        scheduledConsultations.sort { $0.dateTime < $1.dateTime }
    }
}
