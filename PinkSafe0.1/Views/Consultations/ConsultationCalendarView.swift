import SwiftUI
import CoreData

struct ConsultationCalendarView: View {
    @EnvironmentObject var viewModel: ConsultationViewModel
    @State private var selectedMonth: Date = Date()
    @State private var showScheduledConsultations = false
    @State private var selectedDateForNavigation: Date?

    var body: some View {
        VStack {
            // Header do Calendário (Mês e Navegação)
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearFormatter.string(from: selectedMonth))
                    .font(.headline)
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            // Dias da Semana
            HStack {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.top, 5)

            // Grade do Calendário
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonth(selectedMonth), id: \.timeIntervalSinceReferenceDate) { date in
                    if Calendar.current.component(.month, from: date) == Calendar.current.component(.month, from: selectedMonth) {
                        dayView(for: date)
                    } else {
                        Text("") // Espaço vazio para dias de outros meses
                    }
                }
            }
            .padding(.horizontal)
            
            // Link de navegação invisível para ScheduledConsultationsView
            NavigationLink(destination: ScheduledConsultationsView(selectedDate: selectedDateForNavigation), isActive: $showScheduledConsultations) {
                EmptyView()
            }
            .hidden()
        }
    }

    private func dayView(for date: Date) -> some View {
        let day = Calendar.current.component(.day, from: date)
        let hasConsultation = viewModel.scheduledConsultations.contains { consultation in
            Calendar.current.isDate(consultation.dateTime, inSameDayAs: date)
        }

        return VStack {
            Text("\(day)")
                .font(.subheadline)
                .frame(width: 30, height: 30)
                .background(Calendar.current.isDateInToday(date) ? Color.gray.opacity(0.3) : Color.clear)
                .cornerRadius(5)

            if hasConsultation {
                Circle()
                    .fill(Color("principal"))
                    .frame(width: 8, height: 8)
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 8, height: 8)
            }
        }
        .onTapGesture {
            selectedDateForNavigation = date
            showScheduledConsultations = true
        }
    }

    private func daysInMonth(_ date: Date) -> [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: date) else { return [] }
        
        var days: [Date] = []
        let startOfMonth = monthInterval.start
        
        // Adicionar dias da semana anteriores ao início do mês
        let weekdayOfFirstDay = Calendar.current.component(.weekday, from: startOfMonth) // 1 para domingo, 7 para sábado
        let daysBefore = (weekdayOfFirstDay - Calendar.current.firstWeekday + 7) % 7 // Ajuste para o primeiro dia da semana
        if let firstDisplayDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: startOfMonth) {
            for i in 0..<(daysBefore + Calendar.current.range(of: .day, in: .month, for: date)!.count) {
                if let day = Calendar.current.date(byAdding: .day, value: i, to: firstDisplayDate) {
                    days.append(day)
                }
            }
        }
        
        return days
    }

    private func changeMonth(by months: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: months, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
} 