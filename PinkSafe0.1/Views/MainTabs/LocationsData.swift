// Models/LocationsData.swift
import Foundation
import CoreLocation
import SwiftUI

// Enum para as categorias de locais.
enum LocationCategory: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case delegacia = "DEAMs"
    case ongsApoio = "Apoio"
    case saude = "Saúde"
    case academias = "Academias"
    case servicos = "Serviços"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .todos: return "mappin.and.ellipse"
        case .delegacia: return "shield.lefthalf.filled"
        case .ongsApoio: return "heart.fill"
        case .saude: return "cross.case.fill"
        case .academias: return "figure.run"
        case .servicos: return "wrench.and.screwdriver.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .todos: return Color("principal") // Cor principal para a categoria 'Todos'
        case .delegacia: return .red
        case .ongsApoio: return .green
        case .saude: return .blue
        case .academias: return .orange
        case .servicos: return .purple
        }
    }
}

// Struct para representar um local de apoio com sua categoria.
struct SupportLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: LocationCategory
}

// "Banco de dados" estático com a sua lista de locais.
struct LocationsDatabase {
    static let allLocations: [SupportLocation] = [
        // Delegacias da Mulher (DEAMs)
        SupportLocation(name: "DEAM I - Delegacia Especial de Atendimento a Mulher", coordinate: .init(latitude: -15.8083, longitude: -47.8927), category: .delegacia),
        SupportLocation(name: "DEAM II - Delegacia Especial de Atendimento à Mulher II", coordinate: .init(latitude: -15.8208, longitude: -48.1133), category: .delegacia),
        
        // ONGs e Apoio
        SupportLocation(name: "Recomeçar - Associação de Mulheres", coordinate: .init(latitude: -15.7865, longitude: -47.8824), category: .ongsApoio),
        SupportLocation(name: "Centro Especializado de Atendimento A Mulher – CEAM 102 SUL", coordinate: .init(latitude: -15.8003, longitude: -47.8863), category: .ongsApoio),
        SupportLocation(name: "Instituto Mulheres Feminicídio Não", coordinate: .init(latitude: -15.8569, longitude: -48.0708), category: .ongsApoio),
        SupportLocation(name: "Aconchego - Grupo de Apoio à Convivência Familiar e Comunitária", coordinate: .init(latitude: -15.8166, longitude: -47.8966), category: .ongsApoio),
        SupportLocation(name: "Casa Flor Unidade de Acolhimento para Mulheres", coordinate: .init(latitude: -15.8369, longitude: -48.0558), category: .ongsApoio),
        
        // Saúde (Farmácias e Psicólogos)
        SupportLocation(name: "Drogaria Rosário 116 Asa Norte 24h", coordinate: .init(latitude: -15.7661, longitude: -47.8778), category: .saude),
        SupportLocation(name: "Farmácias Descontão 24H", coordinate: .init(latitude: -15.8239, longitude: -48.1136), category: .saude),
        SupportLocation(name: "Drogasil - Guará I", coordinate: .init(latitude: -15.8222, longitude: -47.9839), category: .saude),
        SupportLocation(name: "Drogasil - Asa Sul", coordinate: .init(latitude: -15.7997, longitude: -47.8869), category: .saude),
        SupportLocation(name: "Mulheres de Voz: Comunidade e Clínica", coordinate: .init(latitude: -15.7483, longitude: -47.8681), category: .saude),
        SupportLocation(name: "Flávia Lopes- psicóloga de mulheres e casais", coordinate: .init(latitude: -15.8225, longitude: -47.915), category: .saude),
        SupportLocation(name: "Centro Especializado de Atendimento à Mulher - CEAM Planaltina", coordinate: .init(latitude: -15.6267, longitude: -47.6525), category: .saude),
        
        // Academias
        SupportLocation(name: "Krav Maga - Brasília (Asa Sul)", coordinate: .init(latitude: -15.8119, longitude: -47.8972), category: .academias),
        SupportLocation(name: "Centro de Excelência em Krav Maga - Mestre Kobi | Asa Sul", coordinate: .init(latitude: -15.8033, longitude: -48.0464), category: .academias),
        SupportLocation(name: "Flóriz Academia para mulheres", coordinate: .init(latitude: -15.8378, longitude: -48.0311), category: .academias),
        SupportLocation(name: "SlimFit Studio Guará: Academia Feminina", coordinate: .init(latitude: -15.8247, longitude: -47.9866), category: .academias),
        
        // Serviços (Autoescolas e Salões)
        SupportLocation(name: "Aulas para Habilitados DIRIJA BEM MULHERES", coordinate: .init(latitude: -15.7963, longitude: -47.8813), category: .servicos),
        SupportLocation(name: "Aulas Para Habilitados / Brasília DF", coordinate: .init(latitude: -15.7998, longitude: -47.883), category: .servicos),
        SupportLocation(name: "Elas no Trânsito DF (Aulas para Habilitados DF)", coordinate: .init(latitude: -15.8392, longitude: -48.0569), category: .servicos),
        SupportLocation(name: "Diego Moreira Salão de Beleza", coordinate: .init(latitude: -15.7742, longitude: -47.8769), category: .servicos),
        SupportLocation(name: "Salão de Beleza Maerd Beauty Salon / Asa Sul", coordinate: .init(latitude: -15.8111, longitude: -47.8972), category: .servicos),
        SupportLocation(name: "Lavalle Salão Feminino", coordinate: .init(latitude: -15.7828, longitude: -47.8827), category: .servicos)
    ]
}
