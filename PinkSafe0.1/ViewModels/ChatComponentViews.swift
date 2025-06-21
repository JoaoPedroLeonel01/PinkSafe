//  ChatComponentViews.swift
//  PinkSafe0.1
//
//  Descrição: Contém as Views auxiliares e reutilizáveis para a interface do chat.
//

import SwiftUI

// View para o balão de mensagem
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.principal : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(20)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

// View para o indicador "Digitando..."
struct TypingIndicator: View {
    @State private var numberOfDots = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Text("Digitando")
                .font(.caption)
                .foregroundColor(.gray)
            + Text(String(repeating: ".", count: numberOfDots))
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal)
        .onReceive(timer) { _ in
            numberOfDots = (numberOfDots + 1) % 4
        }
    }
}
