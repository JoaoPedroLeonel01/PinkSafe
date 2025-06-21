// Styles/FilterButtonStyle.swift
// Um estilo de botão personalizado e reutilizável para os filtros.

import SwiftUI

struct FilterButtonStyle: ButtonStyle {
    // A view saberá se o botão está selecionado ou não
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        // configuration.label é o Text() que passamos para o botão
        configuration.label
            .fontWeight(.semibold)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            // A lógica de cores agora está encapsulada e mais confiável aqui
            .background(isSelected ? Color("principal") : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            // Efeito extra: o botão diminui um pouco ao ser pressionado
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            // Animação suave para as transições
            .animation(.easeOut(duration: 0.2), value: isSelected)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
