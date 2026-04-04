// MyProgressView.swift — Growth Analytics & Mastery Overview

import SwiftUI

struct MyProgressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    private var todayString: String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.appBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // 1. Custom Header (Growth Analytics)
                        VStack(alignment: .leading, spacing: 4) {
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
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)

                        // 2. Main Analytics Grid
                        VStack(spacing: 20) {
                            
                            // Monthly Activity Calendar (Matches PWA)
                            ActivityCalendarView()

                            // Lifetime Stats Row
                            HStack(spacing: 12) {
                                StatCard(value: "\(appState.completedDaysTotal)", label: "Total Days Active", icon: "calendar.badge.plus")
                                StatCard(value: "\(appState.streakDays)", label: "Longest Streak", icon: "flame.fill", color: .orange)
                            }

                            // Knowledge Mastery Ring Card
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Knowledge Mastery")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: 32) {
                                    // Mastery Ring (Gauge)
                                    MasteryRing(pct: appState.overallMasteryPct)
                                    
                                    // Counts Breakdown
                                    VStack(alignment: .leading, spacing: 10) {
                                        MasteryRow(color: .primaryGreen, label: "Memorized", count: appState.memorizedCount)
                                        MasteryRow(color: Color(hex: "6366F1"), label: "Learning", count: appState.learningCount)
                                        MasteryRow(color: Color.divider, label: "New", count: max(0, (appState.morningAdhkar.count + appState.eveningAdhkar.count) - appState.memorizedCount - appState.learningCount))
                                    }
                                }
                            }
                            .padding(24)
                            .background(Color.cardBackground)
                            .cornerRadius(AppRadius.md)
                            .cardShadow()

                            // Library Progress
                            VStack(alignment: .leading, spacing: 18) {
                                Text("Library Progress")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                VStack(spacing: 14) {
                                    LibraryProgressRow(label: "Morning Adhkar", pct: appState.morningProgressPct)
                                    LibraryProgressRow(label: "Evening Adhkar", pct: appState.eveningProgressPct)
                                    LibraryProgressRow(label: "Situational Adhkar", pct: appState.dailyProgressPct)
                                }
                            }
                            .padding(20)
                            .background(Color.cardBackground)
                            .cornerRadius(AppRadius.md)
                            .cardShadow()

                            // Quote Box
                            VStack(spacing: 12) {
                                Text("✨")
                                    .font(.system(size: 24))
                                Text("\"The most beloved of deeds to Allah are those that are most consistent, even if they are small.\"")
                                    .font(.system(size: 14, weight: .medium, design: .serif))
                                    .italic()
                                    .foregroundColor(.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            .padding(24)
                            .background(Color.primaryGreen.opacity(0.1))
                            .cornerRadius(AppRadius.md)
                            .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.primaryGreen.opacity(0.2), lineWidth: 1))
                        }
                            .padding(.bottom, 24)
                            
                            // Bottom spacer for floating nav pill
                            Color.clear.frame(height: 100)
                        }
                    }
                }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Internal Components

struct HistoryBar: View {
    let entry: DailyProgressEntry
    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.divider.opacity(0.1))
                    .frame(width: 14, height: 60)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(entry.completionRatio >= 1.0 ? Color.primaryGreen : entry.completionRatio > 0 ? Color(hex: "6366F1") : Color.divider.opacity(0.2))
                    .frame(width: 14, height: max(6, CGFloat(entry.completionRatio) * 60))
            }
            let f = DateFormatter()
            let _ = (f.dateFormat = "d")
            Text(f.string(from: entry.date))
                .font(.system(size: 9))
                .foregroundColor(.textSecondary)
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    var color: Color = .primaryGreen
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
                Spacer()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
    }
}

struct MasteryRing: View {
    let pct: Int
    @State private var animatedPct: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.divider.opacity(0.1), lineWidth: 10)
                .frame(width: 84, height: 84)
            
            Circle()
                .trim(from: 0, to: animatedPct)
                .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 84, height: 84)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.0).delay(0.2), value: animatedPct)
            
            VStack(spacing: -2) {
                Text("\(pct)%")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                Text("Mastery")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .textCase(.uppercase)
            }
        }
        .onAppear {
            animatedPct = CGFloat(pct) / 100.0
        }
    }
}

struct MasteryRow: View {
    let color: Color
    let label: String
    let count: Int
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            Spacer()
            Text("\(count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
    }
}

struct LibraryProgressRow: View {
    let label: String
    let pct: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(pct)%")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primaryGreen)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.divider.opacity(0.2))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primaryGreen)
                        .frame(width: max(0, geo.size.width * CGFloat(pct) / 100.0), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    MyProgressView()
        .environmentObject(AppState())
}
