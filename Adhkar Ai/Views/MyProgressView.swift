// MyProgressView.swift — Daily completion chart

import SwiftUI

struct MyProgressView: View {
    @Environment(\.dismiss) var dismiss

    // Mock 14-day progress data
    private let progressData: [DailyProgressEntry] = {
        var entries: [DailyProgressEntry] = []
        for i in 0..<14 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            let ratio = Double.random(in: 0.2...1.0)
            entries.append(DailyProgressEntry(
                date: date,
                morningCompleted: ratio > 0.4,
                eveningCompleted: ratio > 0.6,
                completionRatio: ratio
            ))
        }
        return entries.reversed()
    }()

    private let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Summary cards
                        HStack(spacing: 12) {
                            ProgressSummaryCard(value: "8", label: "Day Streak 🔥", color: Color(hex: "F59E0B"))
                            ProgressSummaryCard(value: "12", label: "Total Days", color: Color.primaryGreen)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                        // Bar chart
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Last 14 Days")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 16)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .bottom, spacing: 10) {
                                    ForEach(progressData) { entry in
                                        ProgressBar(entry: entry)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 4)
                            }
                        }
                        .padding(.vertical, 16)
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.md)
                        .cardShadow()
                        .padding(.horizontal, 16)

                        // Legend
                        HStack(spacing: 20) {
                            LegendItem(color: .primaryGreen, label: "Morning")
                            LegendItem(color: Color(hex: "6366F1"), label: "Evening")
                            LegendItem(color: Color.divider, label: "Incomplete")
                        }
                        .padding(.horizontal, 16)

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("My Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.primaryGreen)
                }
            }
        }
    }
}

struct ProgressBar: View {
    let entry: DailyProgressEntry

    private var barColor: Color {
        if entry.completionRatio >= 0.8 { return .primaryGreen }
        if entry.completionRatio >= 0.5 { return Color(hex: "6366F1") }
        return Color.divider
    }

    private var dayLabel: String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: entry.date)
    }

    var body: some View {
        VStack(spacing: 6) {
            // Bar
            RoundedRectangle(cornerRadius: 6)
                .fill(barColor)
                .frame(width: 28, height: max(12, CGFloat(entry.completionRatio) * 100))

            // Day number
            Text(dayLabel)
                .font(.system(size: 10))
                .foregroundColor(.textSecondary)
        }
        .frame(height: 120, alignment: .bottom)
    }
}

struct ProgressSummaryCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    var body: some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    MyProgressView()
}
