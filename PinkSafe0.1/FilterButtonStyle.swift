import SwiftUI

struct FilterButtonStyle: ButtonStyle {

    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .fontWeight(.semibold)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(isSelected ? Color("principal") : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isSelected)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
