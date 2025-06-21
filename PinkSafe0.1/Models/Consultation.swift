//
//  Consultation.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

// Models/Consultation.swift
import Foundation

struct Consultation: Identifiable {
    let id = UUID()
    let name: String
    let reason: String
    let dateTime: Date
}
