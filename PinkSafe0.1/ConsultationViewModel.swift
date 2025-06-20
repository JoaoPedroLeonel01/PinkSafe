//
//  ConsultationViewModel.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

// ViewModels/ConsultationViewModel.swift
import SwiftUI

class ConsultationViewModel: ObservableObject {
    @Published var scheduledConsultations: [Consultation] = []
    
    func schedule(name: String, reason: String, dateTime: Date) {
        let newConsultation = Consultation(name: name, reason: reason, dateTime: dateTime)
        scheduledConsultations.append(newConsultation)
        scheduledConsultations.sort { $0.dateTime < $1.dateTime }
    }
}
