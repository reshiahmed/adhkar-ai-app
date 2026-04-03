// ActivityCalendarView.swift — Monthly activity grid matching the PWA
import SwiftUI

struct ActivityCalendarView: View {
    @EnvironmentObject var appState: AppState
    
    private let calendar = Calendar.current
    private let now = Date()
    
    private var monthName: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: now)
    }
    
    private var daysInMonth: [Date?] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: now),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let offset = firstWeekday - 1 // 0 = Sunday, 1 = Monday...
        
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        for day in 1...monthRange.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(monthName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: columns, spacing: 6) {
                // Weekday labels
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                }
                
                // Day squares
                ForEach(0..<daysInMonth.count, id: \.self) { index in
                    if let date = daysInMonth[index] {
                        DaySquare(date: date)
                    } else {
                        Color.clear
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            
            // Legend
            HStack(spacing: 16) {
                LegendItem(color: .primaryGreen, label: "Active")
                LegendItem(color: .white, borderColor: .primaryGreen, label: "Today")
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
    }
}

struct DaySquare: View {
    @EnvironmentObject var appState: AppState
    let date: Date
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var isFuture: Bool {
        date > Date()
    }
    
    private var isActive: Bool {
        let act = appState.activityForDay(date: date)
        return act.morning || act.evening
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isActive ? Color.primaryGreen : (isFuture ? Color.divider.opacity(0.1) : Color.divider.opacity(0.2)))
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(isToday ? Color.primaryGreen : Color.clear, lineWidth: 1.5)
            )
    }
}

private struct LegendItem: View {
    let color: Color
    var borderColor: Color = .clear
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 10, height: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(borderColor, lineWidth: 1)
                )
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
        }
    }
}
