//
//  AssistenteVirtualView.swift
//  PinkSafe0.1
//
//  Created by Joao pedro Leonel on 20/06/25.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct AssistenteVirtualView: View {
    @State private var messages: [Message] = [
        Message(content: "Olá! Eu sou a Luna, sua assistente virtual de segurança. Como posso ajudar você hoje?", isUser: false, timestamp: Date())
    ]
    @State private var newMessage: String = ""
    @State private var isTyping: Bool = false
    
    let sugestoes = [
        "Pontos seguros próximos",
        "Me sinto seguida",
        "Preciso de ajuda urgente",
        "Dicas de segurança"
    ]
    
    func sendMessage(_ content: String) {
        let userMessage = Message(content: content, isUser: true, timestamp: Date())
        messages.append(userMessage)
        newMessage = ""
        
        // Simular digitação do assistente
        isTyping = true
        
        // Simular resposta do assistente após um breve delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = getResponse(for: content)
            let assistantMessage = Message(content: response, isUser: false, timestamp: Date())
            messages.append(assistantMessage)
            isTyping = false
        }
    }
    
    func getResponse(for message: String) -> String {
        let lowercased = message.lowercased()
        
        if lowercased.contains("seguida") || lowercased.contains("perseguida") {
            return """
            Se você suspeita que está sendo seguida, aqui estão algumas ações imediatas que você pode tomar:

            1. Mantenha a calma
            2. Entre em um estabelecimento movimentado (lojas, bancos, restaurantes)
            3. Ligue para alguém de confiança
            4. Se possível, tire fotos discretamente
            5. Em caso de emergência, ligue 190

            Quer que eu mostre os pontos seguros mais próximos de você?
            """
        } else if lowercased.contains("pontos seguros") || lowercased.contains("próximos") {
            return """
            Posso ajudar você a encontrar pontos seguros próximos como:
            
            - Delegacias da Mulher
            - Hospitais
            - Farmácias 24h
            - Postos policiais
            
            Deseja que eu mostre no mapa os pontos mais próximos da sua localização atual?
            """
        } else if lowercased.contains("ajuda") || lowercased.contains("urgente") {
            return """
            Em situações de emergência:
            
            📞 Ligue imediatamente:
            - 190 (Polícia)
            - 180 (Central de Atendimento à Mulher)
            
            🏃‍♀️ Procure um local seguro e movimentado
            
            Quer que eu acione seus contatos de emergência?
            """
        } else if lowercased.contains("dicas") || lowercased.contains("segurança") {
            return """
            Aqui estão algumas dicas importantes de segurança:

            🔹 Compartilhe sua localização com pessoas de confiança
            🔹 Mantenha o celular sempre carregado
            🔹 Tenha números de emergência na discagem rápida
            🔹 Evite caminhar sozinha em locais isolados
            🔹 Use nosso recurso de rastreamento em tempo real
            
            Quer saber mais sobre alguma dessas dicas?
            """
        }
        
        return "Como posso ajudar você? Você pode me perguntar sobre pontos seguros próximos, o que fazer em situações de emergência, ou pedir dicas de segurança."
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Chat messages
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                        if isTyping {
                            TypingIndicator()
                        }
                    }
                    .padding()
                }
                
                // Primeiro divisor
                Rectangle()
                    .fill(Color.principal)
                    .frame(height: 1)
                
                // Sugestões
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(sugestoes, id: \.self) { sugestao in
                            Button(action: {
                                sendMessage(sugestao)
                            }) {
                                Text(sugestao)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.principal.opacity(0.2))
                                    .foregroundColor(.principal)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }
                
                // Input area
                HStack(spacing: 12) {
                    TextField("Digite sua mensagem...", text: $newMessage)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(25)
                    
                    Button(action: {
                        if !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            sendMessage(newMessage)
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.principal)
                    }
                }
                .padding()
            }
            .navigationTitle("Assistente Virtual")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.isUser ? Color.principal : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .black)
                    .cornerRadius(20)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var numberOfDots = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Text("Digitando")
                .foregroundColor(.gray)
            + Text(String(repeating: ".", count: numberOfDots))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.leading)
        .onReceive(timer) { _ in
            numberOfDots = (numberOfDots + 1) % 4
        }
    }
}

#Preview {
    AssistenteVirtualView()
} 
