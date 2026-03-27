// MasteryView.swift — Spaced repetition memorization dashboard

import SwiftUI

struct MasteryView: View {
    @EnvironmentObject var appState: AppState

    // Mock mastery data — in v1 derived from morning/evening progress
    private var totalAdhkar: Int { appState.morningAdhkar.count + appState.eveningAdhkar.count }
    private var reviewed: Int { appState.morningCompleted + appState.eveningCompleted }
    private var memorized: Int { max(0, reviewed - 3) }
    private var dueToday: Int { max(0, totalAdhkar - reviewed) }
    private var overallProgress: Double {
        totalAdhkar > 0 ? Double(reviewed) / Double(totalAdhkar) : 0
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 64)

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
                        MasteryStatCard(value: reviewed, label: "Reviewed", color: .primaryGreen)
                        MasteryStatCard(value: memorized, label: "Memorized", color: Color(hex: "7C3AED"))
                        MasteryStatCard(value: dueToday, label: "Due Today", color: Color(hex: "D97706"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

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
                            MasteryCategoryRow(category: cat)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    }

                    Spacer().frame(height: 24)
                }
            }
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
    @State private var showComingSoon = false

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
                    showComingSoon = true
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
                    showComingSoon = true
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
        .alert("Coming Soon", isPresented: $showComingSoon) {
            Button("OK") {}
        } message: {
            Text("Spaced repetition review will be available in v2.")
        }
    }
}

#Preview {
    MasteryView()
        .environmentObject(AppState())
}
