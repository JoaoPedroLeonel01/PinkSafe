//
//  EmergencyContactModel.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

import SwiftUI

struct EmergencyContact: Identifiable {
    let id = UUID()
    var name: String
    var phone: String
    var relationship: String
} 
