// Data/NewsData.swift
// Lista de notícias com nomes de imagens locais dos Assets.

import Foundation

let newsData: [News] = [
    // Segurança pública / Violência
    News(title: "Brasil tem recorde de feminicídios: 4 mulheres são mortas por dia",
         category: "Segurança",
         imageURL: "violencia-feminicidio-recorde", // nome da imagem salva nos Assets
         description: "Dados do Mapa da Segurança Pública apontam que em 2024 foram registrados 1.459 feminicídios, média de quatro por dia, o maior índice da série histórica.",
         date: "12 Jun 2025",
         source: "UOL",
         sourceURL: "https://noticias.uol.com.br"),

    // Economia / Transparência
    News(title: "Economia é coisa de mulher, mas orçamento para mulheres ainda é pouco transparente",
         category: "Economia",
         imageURL: "economia-orcamento-mulheres",
         description: "Relatório da Pública mostra que, apesar de R$ 277 milhões previstos, mais de 70 % do orçamento para mulheres em 2025 depende de emendas parlamentares, sem transparência.",
         date: "07 Mar 2025",
         source: "Agência Pública",
         sourceURL: "https://apublica.org/"),

    // Política / Representação
    News(title: "ONU Mulheres Brasil abre inscrições para Grupo Assessor da Sociedade Civil",
         category: "Política",
         imageURL: "onu-mulheres-gasc",
         description: "Chamadas abertas até 19 maio para seleção de 15 representantes da sociedade civil no GASC-Brasil, fortalecendo diálogo sobre políticas para mulheres.",
         date: "17 Apr 2025",
         source: "ONU Mulheres Brasil",
         sourceURL: "https://www.onumulheres.org.br/"),

    // Direitos / Relatório Socioeconômico
    News(title: "Ministério lança Relatório Socioeconômico da Mulher – Raseam 2025",
         category: "Direitos",
         imageURL: "raseam-2025-lancamento",
         description: "Raseam 2025 traz 328 indicadores sobre desigualdades de gênero no Brasil, com dados por raça, região, renda e saúde, orientando políticas públicas.",
         date: "25 Mar 2025",
         source: "Agência Gov",
         sourceURL: "https://agenciagov.ebc.com.br/"),

    // Sociedade / Trabalho
    News(title: "Mulheres da saúde e educação cobram equidade de gênero e salarial",
         category: "Sociedade",
         imageURL: "mulheres-saude-educacao",
         description: "A maioria no setor, as profissionais relatam sobrecarga, desvalorização e machismo – e pedem mudanças concretas de políticas e reconhecimento salarial.",
         date: "30 Apr 2025",
         source: "Brasil de Fato",
         sourceURL: "https://www.brasildefato.com.br/"),

    // Representação / Parlamento
    News(title: "Brasil é o 133º país em representatividade parlamentar feminina",
         category: "Política",
         imageURL: "representatividade-parlamentar-feminina",
         description: "Levantamento da ONU Mulheres e UIP revela que o Brasil ocupa apenas a 133ª posição em ranking de representação de mulheres no parlamento.",
         date: "Maio 2025",
         source: "Forbes Brasil",
         sourceURL: "https://forbes.com.br/")
]
