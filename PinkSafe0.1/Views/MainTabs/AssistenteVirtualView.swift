import SwiftUI

struct AssistenteVirtualView: View {

    @State private var messages: [Message] = [
        Message(content: "Olá! Eu sou a Luna, sua assistente virtual de segurança. Como posso ajudar você hoje? Se desejar, posso fazer uma avaliação de risco (Formulário FRIDA).", isUser: false, timestamp: Date())
    ]
    @State private var newMessage: String = ""
    @State private var isTyping: Bool = false

    @State private var isFridaTestActive = false
    @State private var currentFridaQuestionIndex = 0
    @State private var fridaScore = 0

    let sugestoes = [
        "Avaliação de Risco",
        "Me sinto seguida",
        "Preciso de ajuda urgente",
        "Dicas de segurança"
    ]

    let fridaQuestions = [
        (question: "O agressor já fez ameaças de morte a você ou a seus filhos?", score: 3),
        (question: "O agressor já usou ou ameaçou usar uma arma (faca, revólver, etc.) contra você?", score: 3),
        (question: "Você sente que o agressor é capaz de te matar?", score: 3),
        (question: "O agressor já tentou te estrangular (sufocar)?", score: 2),
        (question: "A violência física tem se tornado mais frequente ou mais grave?", score: 2),
        (question: "O agressor é extremamente ciumento ou possessivo, controlando suas ações, roupas e amizades?", score: 2),
        (question: "O agressor já te perseguiu, espionou ou vigiou (stalkeou)?", score: 2),
        (question: "O agressor faz uso abusivo de álcool ou drogas?", score: 1),
        (question: "O agressor tem acesso a alguma arma de fogo?", score: 1),
        (question: "Você já precisou de atendimento médico por causa da violência dele?", score: 1),
        (question: "Ele já te forçou a ter relações sexuais contra sua vontade?", score: 1)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

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

                if !isFridaTestActive {
                    VStack(spacing: 0) {
                        Rectangle().fill(Color.principal).frame(height: 1)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(sugestoes, id: \.self) { sugestao in
                                    Button(action: { handleMessageSend(sugestao) }) {
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
                    }
                }

                HStack(spacing: 12) {
                    TextField(isFridaTestActive ? "Responda 'Sim' ou 'Não'..." : "Digite sua mensagem...", text: $newMessage)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(25)
                    
                    Button(action: {
                        if !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            handleMessageSend(newMessage)
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
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    func handleMessageSend(_ content: String) {
        let userMessage = Message(content: content, isUser: true, timestamp: Date())
        messages.append(userMessage)
        newMessage = ""
        isTyping = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if isFridaTestActive {
                processFridaAnswer(content)
            } else {
                let response = getStandardResponse(for: content)
                let assistantMessage = Message(content: response, isUser: false, timestamp: Date())
                messages.append(assistantMessage)
            }
            isTyping = false
        }
    }
    
    func getStandardResponse(for message: String) -> String {
        let lowercased = message.lowercased()
        
        if lowercased.contains("avaliação de risco") || lowercased.contains("teste frida") || lowercased.contains("teste de risco") {
            startFridaTest()
            return "Entendido. Para te ajudar a entender melhor a sua situação, vamos iniciar o Formulário de Avaliação de Risco. Por favor, responda às próximas perguntas com 'Sim' ou 'Não'. Você pode cancelar a qualquer momento digitando 'Cancelar'."
        }
        
        if lowercased.contains("seguida") || lowercased.contains("perseguida") {
            return "Se você suspeita que está sendo seguida, mantenha a calma, entre em um local público movimentado e ligue para alguém de confiança. Se a ameaça for imediata, ligue 190. Quer que eu mostre os pontos seguros próximos?"
        } else if lowercased.contains("pontos seguros") {
            return "Posso te ajudar a encontrar Delegacias da Mulher, Hospitais e outros pontos de apoio. Deseja que eu mostre no mapa os pontos mais próximos da sua localização atual?"
        } else if lowercased.contains("ajuda") || lowercased.contains("urgente") {
            return "Em situações de emergência, ligue para 190 (Polícia) ou 180 (Central de Atendimento à Mulher). Se puder, acione um contato de emergência. Você está em um local seguro agora?"
        } else if lowercased.contains("dicas") || lowercased.contains("segurança") {
            return "Claro! Uma dica importante é sempre compartilhar sua localização em tempo real com alguém de confiança ao sair. Mantenha também os números de emergência na discagem rápida."
        }
        
        return "Como posso te ajudar? Você pode me perguntar sobre pontos seguros, o que fazer em emergências, ou iniciar uma 'Avaliação de Risco'."
    }

    func startFridaTest() {
        isFridaTestActive = true
        currentFridaQuestionIndex = 0
        fridaScore = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            askNextFridaQuestion()
        }
    }
    
    func askNextFridaQuestion() {
        guard currentFridaQuestionIndex < fridaQuestions.count else {
            endFridaTest()
            return
        }
        
        let questionData = fridaQuestions[currentFridaQuestionIndex]
        let assistantMessage = Message(content: questionData.question, isUser: false, timestamp: Date())
        messages.append(assistantMessage)
    }

    func processFridaAnswer(_ answer: String) {
        let lowercasedAnswer = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        let simVariations = ["sim", "s", "claro", "quero", "isso", "afirmativo", "positivo", "com certeza"]
        let naoVariations = ["não", "nao", "n", "nunca", "negativo", "de jeito nenhum", "jamais"]

        let isAffirmative = simVariations.contains { variation in lowercasedAnswer.contains(variation) }
        let isNegative = naoVariations.contains { variation in lowercasedAnswer.contains(variation) }

        if lowercasedAnswer == "cancelar" {
            isFridaTestActive = false
            messages.append(Message(content: "Avaliação cancelada. Estou aqui se precisar de algo.", isUser: false, timestamp: Date()))
            return
        }
        
        if isAffirmative {
            let questionData = fridaQuestions[currentFridaQuestionIndex]
            fridaScore += questionData.score
        } else if !isNegative {
            messages.append(Message(content: "Desculpe, não entendi. Por favor, responda com 'Sim' ou 'Não'.", isUser: false, timestamp: Date()))
            askNextFridaQuestion()
            return
        }

        currentFridaQuestionIndex += 1
        askNextFridaQuestion()
    }
    
    func endFridaTest() {
        isFridaTestActive = false
        var level: String
        var recommendation: String
        
        switch fridaScore {
        case 0...5:
            level = "RISCO BAIXO"
            recommendation = "Fique atenta a qualquer sinal de mudança no comportamento do agressor. Monitore a situação e converse com alguém de sua confiança. Busque orientação em um Centro de Referência da Mulher (CRAM)."
        case 6...12:
            level = "RISCO MÉDIO"
            recommendation = "O risco à sua segurança é considerável. É fortemente recomendado que você procure a Delegacia da Mulher (DEAM) para registrar um boletim de ocorrência e solicitar uma Medida Protetiva de Urgência."
        default: // 13 ou mais
            level = "RISCO ALTO"
            recommendation = "Você está em uma situação de perigo grave. Sua vida pode estar em risco. Procure ajuda IMEDIATAMENTE. Ligue para 190 (Polícia Militar) agora. Se não for possível, saia de casa e vá para um local seguro (casa de parentes, amigos, ou um abrigo)."
        }
        
        let finalMessage = """
        Avaliação concluída.
        
        **Nível de Risco: \(level)**
        
        **Recomendações:**
        \(recommendation)
        
        **Lembre-se:** Você não está sozinha. Os números mais importantes são **190 (Polícia - Emergência)** e **180 (Central de Atendimento à Mulher - Denúncia e Orientação)**.
        """
        
        messages.append(Message(content: finalMessage, isUser: false, timestamp: Date()))
    }
}


#Preview {
    AssistenteVirtualView()
}
