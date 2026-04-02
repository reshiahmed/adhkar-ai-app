// MasteryView.swift — Spaced repetition memorization dashboard

import SwiftUI

struct MasteryView: View {
    @EnvironmentObject var appState: AppState

    // Actual mastery data
    private var totalAdhkar: Int { (appState.morningAdhkar + appState.eveningAdhkar).filter { $0.isVisible }.count }
    private var reviewedCount: Int { appState.morningCompleted + appState.eveningCompleted }
    private var memorizedCount: Int { appState.memorizedCount }
    private var dueTodayCount: Int { appState.itemsDueToday.count }
    private var overallProgress: Double {
        totalAdhkar > 0 ? Double(memorizedCount) / Double(totalAdhkar) : 0
    }
    
    @State private var sessionToShow: SessionConfig?
    
    struct SessionConfig: Identifiable {
        let id = UUID()
        let items: [Dhikr]
        let mode: MasterySessionView.MasteryMode
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header spacer (for fixed glass header + status bar)
                    Color.clear.frame(height: 110)

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 0) {
                            Text("Mastery")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryGreen)
                        }
                        Text("Track your memorization journey")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                    // Stats row
                    HStack(spacing: 12) {
                        MasteryStatCard(value: reviewedCount, label: "Reviewed", color: .primaryGreen)
                        MasteryStatCard(value: memorizedCount, label: "Memorized", color: Color(hex: "7C3AED"))
                        MasteryStatCard(value: dueTodayCount, label: "Due Today", color: Color(hex: "D97706"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    
                    // Main Action Area
                    if dueTodayCount > 0 {
                        Button {
                            sessionToShow = SessionConfig(items: appState.itemsDueToday, mode: .review)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Start Daily Session")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("\(dueTodayCount) items are waiting for review")
                                        .font(.system(size: 13))
                                        .opacity(0.8)
                                }
                                Spacer()
                                Image(systemName: "play.fill")
                                    .font(.system(size: 20))
                                    .padding(12)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .foregroundColor(.white)
                            .padding(24)
                            .background(
                                LinearGradient(
                                    colors: [Color.primaryGreen, Color(hex: "3CB87A")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(24)
                            .cardShadow()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)
                    }

                    // Progress wheel
                    ZStack {
                        Circle()
                            .stroke(Color.divider, lineWidth: 14)
                        Circle()
                            .trim(from: 0, to: overallProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.primaryGreen, Color(hex: "3CB87A")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 14, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.0), value: overallProgress)

                        VStack(spacing: 4) {
                            Text("\(Int(overallProgress * 100))%")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.textPrimary)
                            Text("Overall")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 28)

                    // Per-category review/test rows
                    VStack(spacing: 0) {
                        Text("Practice Sessions")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 14)

                        ForEach(MasteryCategory.allCases) { cat in
                            MasteryCategoryRow(category: cat) { mode in
                                let items = appState.dueItems(for: cat.adhkarCategory)
                                if items.isEmpty {
                                    // Handle no items due? (Allow practice anyway set in mode?)
                                }
                                sessionToShow = SessionConfig(items: items, mode: mode)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)
                        }
                    }

                    // Bottom spacer for floating nav pill
                    Color.clear.frame(height: 100)
                }
            }
        }
        .sheet(item: $sessionToShow) { config in
            MasterySessionView(items: config.items, mode: config.mode)
        }
    }
}

// MARK: - Stat Card
struct MasteryStatCard: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text("\(value)")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
    }
}

// MARK: - Category row
enum MasteryCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case morning = "Morning Adhkar"
    case evening = "Evening Adhkar"
    case daily   = "Daily Du'as"

    var icon: String {
        switch self {
        case .morning: return "sun.min"
        case .evening: return "moon"
        case .daily:   return "clock"
        }
    }
    
    var adhkarCategory: AdhkarCategory {
        switch self {
        case .morning: return .morning
        case .evening: return .evening
        case .daily:   return .mosque // Placeholder
        }
    }

    var color: Color {
        switch self {
        case .morning: return Color(hex: "F59E0B")
        case .evening: return Color(hex: "6366F1")
        case .daily:   return Color.primaryGreen
        }
    }
}

struct MasteryCategoryRow: View {
    let category: MasteryCategory
    let onStartSession: (MasterySessionView.MasteryMode) -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(category.color.opacity(0.15))
                    .frame(width: 42, height: 42)
                Image(systemName: category.icon)
                    .font(.system(size: 18))
                    .foregroundColor(category.color)
            }

            Text(category.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                Button {
                    onStartSession(.review)
                } label: {
                    Text("Review")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.lightGreen)
                        .cornerRadius(AppRadius.full)
                }
                Button {
                    onStartSession(.test)
                } label: {
                    Text("Test")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.primaryGreen)
                        .cornerRadius(AppRadius.full)
                }
            }
        }
        .padding(14)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
    }
}

#Preview {
    MasteryView()
        .environmentObject(AppState())
}
