// MyProgressView.swift — Growth Analytics & Mastery Overview
import SwiftUI

struct MyProgressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    private var todayString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d, yyyy"
        return f.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // 1. Header: Growth Analytics with Overall Mastery
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("Growth")
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.textPrimary)
                                        Text(" Analytics")
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.primaryGreen)
                                    }
                                    Text(todayString)
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                // Overall Mastery Badge (Top Right)
                                MasterySummaryBadge(pct: appState.overallMasteryPct)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                        // 2. Primary Streak Card
                        StreakCard(streak: appState.streakDays)
                            .padding(.horizontal, 24)

                        // 3. Side-by-Side Stat Boxes
                        HStack(spacing: 16) {
                            StatBox(label: "TOTAL DAYS ACTIVE", value: "\(appState.completedDaysTotal)")
                            StatBox(label: "LONGEST STREAK", value: "\(appState.streakDays)") 
                        }
                        .padding(.horizontal, 24)

                        // 4. Monthly Activity Calendar
                        ActivityCalendarCard()
                            .padding(.horizontal, 24)

                        // 5. Knowledge Mastery (Donut)
                        KnowledgeMasteryCard()
                            .padding(.horizontal, 24)
                        
                        // 6. Library Progress
                        LibraryProgressCard()
                            .padding(.horizontal, 24)

                        // 7. Quote Box
                        QuoteBox()
                            .padding(.horizontal, 24)
                        
                        Color.clear.frame(height: 120)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Components

struct StreakCard: View {
    let streak: Int
    let days = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. Top Section: Icon & Counter
            HStack(spacing: 20) {
                // Squircle Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "drop.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryGreen.opacity(0.6))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(streak)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("Day Streak")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primaryGreen.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Divider()
                .background(Color.divider.opacity(0.1))
                .padding(.horizontal, 20)
            
            // 2. Weekly Progress
            HStack(spacing: 0) {
                let currentWeekday = Calendar.current.component(.weekday, from: Date()) // 1 = Sunday, 7 = Saturday
                
                ForEach(0..<7) { index in
                    // Adjust index to match Swift's 1-indexed weekday (S M T W T F S)
                    let isToday = (index + 1 == currentWeekday)
                    
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(isToday ? Color.primaryGreen : Color.divider.opacity(0.15), lineWidth: 2)
                                .frame(width: 40, height: 40)
                            
                            Text(days[index])
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isToday ? .primaryGreen : .textSecondary.opacity(0.5))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 24)
        }
        .background(Color.cardBackground)
        .cornerRadius(28)
        .cardShadow()
    }
}

struct StatBox: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.textSecondary)
                .tracking(0.5)
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primaryGreen)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .cardShadow()
    }
}

struct ActivityCalendarCard: View {
    @EnvironmentObject var appState: AppState
    
    private var monthName: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: Date()).uppercased()
    }
    
    private var calendarDays: [Date?] {
        let calendar = Calendar.current
        let now = Date()
        guard let range = calendar.range(of: .day, in: .month, for: now),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }
        
        let weekdayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1 // 0 = Sunday
        var days: [Date?] = Array(repeating: nil, count: weekdayOffset)
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        return days
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text(monthName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.textSecondary.opacity(0.8))
                    .tracking(1.0)
                Spacer()
                Text("ACTIVITY")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.primaryGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primaryGreen.opacity(0.1))
                    .cornerRadius(4)
            }
            .padding(.horizontal, 4)
            
            VStack(spacing: 16) {
                // Weekday Row
                HStack(spacing: 0) {
                    let weekdayInitials = ["S","M","T","W","T","F","S"]
                    ForEach(0..<7) { i in
                        Text(weekdayInitials[i])
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.textSecondary.opacity(0.3))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Actual Grid
                let days = calendarDays
                let rows = Int(ceil(Double(days.count) / 7.0))
                
                VStack(spacing: 10) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<7) { col in
                                let index = row * 7 + col
                                if index < days.count, let date = days[index] {
                                    DayCell(date: date)
                                } else {
                                    Color.clear
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 16)
                                }
                            }
                        }
                    }
                }
            }
            
            // Legend
            HStack(spacing: 16) {
                LegendItem(color: .primaryGreen, label: "Full")
                LegendItem(color: .primaryGreen.opacity(0.3), label: "Partial")
                LegendItem(color: .divider.opacity(0.1), label: "None", isStroke: true)
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(28)
        .cardShadow()
    }
}

private struct DayCell: View {
    @EnvironmentObject var appState: AppState
    let date: Date
    
    private var color: Color {
        let activity = appState.activityForDay(date: date)
        if activity.morning && activity.evening {
            return .primaryGreen
        } else if activity.morning || activity.evening {
            return .primaryGreen.opacity(0.3)
        } else {
            return Color.secondary.opacity(0.15)
        }
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 24, height: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isToday ? Color.primaryGreen : Color.clear, lineWidth: 1.5)
                )
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LegendItem: View {
    let color: Color
    let label: String
    var isStroke: Bool = false
    
    var body: some View {
        HStack(spacing: 6) {
            if isStroke {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(color, lineWidth: 1.5)
                    .frame(width: 12, height: 8)
            } else {
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: 12, height: 8)
            }
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.textSecondary.opacity(0.6))
        }
    }
}



struct KnowledgeMasteryCard: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Knowledge Mastery")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("All Time")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.textSecondary.opacity(0.5))
            }
            
            HStack(spacing: 24) {
                // Donut Chart
                ZStack {
                    Circle()
                        .stroke(Color.divider.opacity(0.08), lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: CGFloat(appState.overallMasteryPct) / 100.0)
                        .stroke(
                            AngularGradient(
                                colors: [.primaryGreen, .primaryGreen.opacity(0.7), .primaryGreen],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 14, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8, dampingFraction: 0.7), value: appState.overallMasteryPct)
                    
                    VStack(spacing: 2) {
                        Text("\(appState.overallMasteryPct)%")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                        Text("Mastered")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.textSecondary)
                    }
                }
                .frame(width: 100, height: 100)
                .padding(.leading, 8)
                
                // Status Pills
                VStack(alignment: .leading, spacing: 10) {
                    MasteryStatusPill(color: .primaryGreen, label: "Memorized", count: appState.memorizedCount)
                    MasteryStatusPill(color: .orange, label: "Learning", count: appState.learningCount)
                    MasteryStatusPill(color: Color.textSecondary.opacity(0.3), label: "Remaining", count: 18) // Mock remaining for visual
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .cornerRadius(28)
        .cardShadow()
    }
}

struct MasteryStatusPill: View {
    let color: Color
    let label: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(color)
                .frame(width: 4, height: 14)
            
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text("\(count)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.divider.opacity(0.05))
                .cornerRadius(4)
        }
        .frame(maxWidth: .infinity)
    }
}

struct LibraryProgressCard: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("LIBRARY PROGRESS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.textSecondary.opacity(0.6))
                .tracking(0.8)
            
            VStack(spacing: 24) {
                LibraryBar(label: "Morning", pct: appState.morningProgressPct)
                LibraryBar(label: "Evening", pct: appState.eveningProgressPct)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .cornerRadius(24)
        .cardShadow()
    }
}

struct LibraryBar: View {
    let label: String
    let pct: Int
    var body: some View {
        HStack(spacing: 16) {
            Text(label)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.textPrimary)
                .frame(width: 80, alignment: .leading)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.divider.opacity(0.08))
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.primaryGreen)
                        .frame(width: geo.size.width * CGFloat(pct) / 100.0, height: 8)
                }
                .padding(.vertical, 4)
            }
            .frame(height: 16)
            
            Text("\(pct)%")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.primaryGreen)
                .frame(width: 40, alignment: .trailing)
        }
    }
}

struct QuoteBox: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkle")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.primaryGreen.opacity(0.5))
            
            Text("\"The most beloved of deeds to Allah are those that are most consistent, even if they are small.\"")
                .font(.system(size: 15, weight: .medium, design: .serif))
                .italic()
                .foregroundColor(.textPrimary.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.lightGreen.opacity(0.4))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.primaryGreen.opacity(0.08), lineWidth: 1)
        )
    }
}
