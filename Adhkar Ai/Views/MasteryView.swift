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

    private func visibleItems(for category: AdhkarCategory) -> [Dhikr] {
        let items = (category == .morning ? appState.morningAdhkar : appState.eveningAdhkar)
        return items.filter { $0.isVisible }
    }
    
    struct SessionConfig: Identifiable {
        let id = UUID()
        let items: [Dhikr]
        let mode: MasterySessionView.MasteryMode
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // 1. Header with Compact Mastery Badge
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mastery")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.primaryGreen)
                                Text("Track your memorization journey")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary.opacity(0.8))
                            }
                            Spacer()
                            
                            // Overall Progress Badge (Top Right)
                            MasterySummaryBadge(pct: appState.overallMasteryPct)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                    // 2. Premium Stat Row
                    HStack(spacing: 12) {
                        MasteryStatBox(label: "Reviewed", value: "\(reviewedCount)", icon: "checkmark.seal.fill", color: .primaryGreen)
                        MasteryStatBox(label: "Memorized", value: "\(memorizedCount)", icon: "star.fill", color: Color(hex: "7C3AED"))
                        MasteryStatBox(label: "Due Today", value: "\(dueTodayCount)", icon: "clock.fill", color: Color(hex: "F59E0B"))
                    }
                    .padding(.horizontal, 24)
                    
                    // 3. Primary Action Card (Start Daily Session)
                    if dueTodayCount > 0 {
                        Button {
                            sessionToShow = SessionConfig(items: appState.itemsDueToday, mode: .review)
                        } label: {
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Start Daily Session")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("\(dueTodayCount) items are waiting for review")
                                        .font(.system(size: 14))
                                        .opacity(0.9)
                                }
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 18))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(24)
                            .background {
                                ZStack {
                                    LinearGradient(
                                        colors: [Color.primaryGreen, Color(hex: "3CB87A")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    
                                    // Liquid shine overlay
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.35), Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                }
                            }
                            .cornerRadius(28)
                            .overlay {
                                RoundedRectangle(cornerRadius: 28)
                                    .strokeBorder(Color.white.opacity(0.35), lineWidth: 0.8)
                            }
                            .cardShadow()
                        }
                        .padding(.horizontal, 24)
                    }

                    // 4. Practice Sessions List
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Practice Sessions")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, 4)

                        VStack(spacing: 12) {
                            ForEach(MasteryCategory.allCases) { cat in
                                MasteryCategoryCard(category: cat) { mode in
                                    let items: [Dhikr]
                                    if mode == .review {
                                        items = visibleItems(for: cat.adhkarCategory)
                                    } else {
                                        items = appState.dueItems(for: cat.adhkarCategory)
                                    }
                                    sessionToShow = SessionConfig(items: items, mode: mode)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    // Bottom spacer
                    Color.clear.frame(height: 120)
                }
            }
        }
        .sheet(item: $sessionToShow) { config in
            MasterySessionView(items: config.items, mode: config.mode)
        }
    }
}

// MARK: - Components

struct MasteryStatBox: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                Text(label.uppercased())
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.textSecondary.opacity(0.6))
                    .tracking(0.5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.4), lineWidth: 0.5)
            }
        }
        .cardShadow()
    }
}

struct MasteryCategoryCard: View {
    let category: MasteryCategory
    let onStartSession: (MasterySessionView.MasteryMode) -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(category.color.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(category.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
            }

            Spacer()

            VStack(spacing: 8) {
                Button { onStartSession(.review) } label: {
                    Text("Review")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.primaryGreen)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(minWidth: 80)
                        .background(Color.primaryGreen.opacity(0.08))
                        .cornerRadius(12)
                }

                Button { onStartSession(.test) } label: {
                    Text("Test")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(minWidth: 80)
                        .background(Color.primaryGreen)
                        .cornerRadius(12)
                        .cardShadow()
                }
            }
        }
        .padding(16)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                
                // Colored rim-light matching category
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [category.color.opacity(0.6), category.color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
            }
        }
        .cardShadow()
    }
}



enum MasteryCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case morning = "Morning Adhkar"
    case evening = "Evening Adhkar"
    case daily   = "Daily Du'as"

    var icon: String {
        switch self {
        case .morning: return "sun.max.fill"
        case .evening: return "moon.fill"
        case .daily:   return "clock.fill"
        }
    }
    
    var adhkarCategory: AdhkarCategory {
        switch self {
        case .morning: return .morning
        case .evening: return .evening
        case .daily:   return .mosque
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

#Preview {
    MasteryView()
        .environmentObject(AppState())
}
