# 💖 PinkSafe

**PinkSafe** é um aplicativo iOS desenvolvido com Swift e SwiftUI, focado na segurança, acolhimento e apoio emocional para mulheres. Com uma abordagem multifacetada, o app oferece assistente virtual, mapeamento de locais seguros, gestão de contatos de emergência e um feed de notícias relevantes.

## 🚀 Funcionalidades

- 🧠 **Assistente Virtual "Luna"**  
  Interface de chat interativo com orientações, acolhimento e um formulário de avaliação de risco.

- 🗺️ **Mapa com Locais de Apoio**  
  Exibe pontos seguros com base na localização da usuária, usando MapKit e filtros por categoria.

- 📞 **Contatos de Emergência**  
  Gerencie contatos de confiança e acione-os rapidamente em situações de risco.

- 📰 **Feed de Notícias**  
  Acesso a conteúdos atualizados sobre direitos, saúde, segurança e atualidades.

- 📅 **Consultas com Psicólogas**  
  Agendamento de sessões de apoio emocional com interface intuitiva de calendário.

## 🧩 Arquitetura do Projeto

O projeto segue o padrão **MVVM (Model-View-ViewModel)**, com separação clara de responsabilidades:
PinkSafe/
├── Application/
│   ├── PinkSafe0_1App.swift
│   ├── ContentView.swift
│   └── View+Extensions.swift
├── Models/
│   ├── Consultation.swift
│   ├── EmergencyContactModel.swift
│   ├── FridaQuestion.swift
│   ├── Message.swift
│   └── News.swift
├── Services/
│   ├── LocationSearchService.swift
│   └── NewsService.swift
├── ViewModels/
│   ├── ConsultationViewModel.swift
│   └── NewsViewModel.swift
├── Views/
│   ├── AssistenteVirtualView.swift
│   ├── MapaView.swift
│   ├── EmergencyContactsView.swift
│   ├── NewsView.swift
│   ├── PerfilView.swift
│   └── MainTabs/
├── Components/
│   ├── ChatComponentViews.swift
│   └── CustomMapView.swift
├── Consultations/
│   ├── ConsultationCalendarView.swift
│   ├── PsychologistConsultationView.swift
│   └── ScheduledConsultationsView.swift
├── EmergencyContacts/
│   └── AddEmergencyContactView.swift
└── Data/
├── LocationsData.swift
└── NewsData.swift

## 🛠️ Tecnologias Utilizadas

- **Swift & SwiftUI** – Desenvolvimento nativo declarativo para iOS
- **MVVM** – Organização limpa e escalável
- **MapKit & CoreLocation** – Funcionalidades de geolocalização
- **URLSession & Codable** – Consumo de APIs RESTful
- **@State / @StateObject / @EnvironmentObject** – Gerenciamento de estado reativo
- **DispatchQueue** – Execução assíncrona
- **UUID & Date** – Identificação única e controle temporal



Contribuições são bem-vindas! Para sugerir melhorias, envie um pull request ou abra uma issue com sua ideia ou correção.

PinkSafe — Um app por mulheres, para mulheres.
Desenvolvido com 💜 por Maria Clara, Cauê Carneiro, João Leonel e Mariana.
---


