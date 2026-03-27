// DailyView.swift — Situational du'as by category (expandable grid)

import SwiftUI

struct DailyView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: AdhkarCategory? = nil

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            if let selected = selectedCategory {
                // Detail view for a category
                DailyCategoryDetailView(category: selected) {
                    withAnimation { selectedCategory = nil }
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 64)

                        // Page header
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 0) {
                                Text("Daily")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.primaryGreen)
                                Text(" Adhkar")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.textPrimary)
                            }
                            Text("Situational du'as for everyday life")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                        // Category grid
                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(AdhkarData.dailyCategories, id: \.self) { category in
                                DailyCategoryCard(
                                    category: category,
                                    count: AdhkarData.adhkar(for: category).count
                                ) {
                                    withAnimation(.easeInOut) { selectedCategory = category }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
    }
}

// MARK: - Category Card (grid item)
struct DailyCategoryCard: View {
    let category: AdhkarCategory
    let count: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                // Emoji
                Text(category.emoji)
                    .font(.system(size: 32))

                Spacer()

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.displayName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text("\(count) du\u{02BC}a\(count == 1 ? "" : "s")")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .frame(height: 130)
            .background(Color.cardBackground)
            .cornerRadius(AppRadius.md)
            .cardShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Category Detail
struct DailyCategoryDetailView: View {
    let category: AdhkarCategory
    let onBack: () -> Void

    private var adhkar: [Dhikr] { AdhkarData.adhkar(for: category) }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 64)

            ScrollView {
                VStack(spacing: 0) {
                    // Back + title
                    HStack(spacing: 12) {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .frame(width: 36, height: 36)
                                .background(Color.cardBackground)
                                .cornerRadius(10)
                                .cardShadow()
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(category.emoji + " " + category.displayName)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.textPrimary)
                            Text("\(adhkar.count) du\u{02BC}a\(adhkar.count == 1 ? "" : "s")")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    if adhkar.isEmpty {
                        VStack(spacing: 12) {
                            Text("🕌")
                                .font(.system(size: 48))
                            Text("Coming soon")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(adhkar) { dhikr in
                                DhikrCardView(
                                    dhikr: dhikr,
                                    isEditMode: false,
                                    onIncrement: {},
                                    onToggleVisibility: {}
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .transition(.move(edge: .trailing))
    }
}

#Preview {
    DailyView()
        .environmentObject(AppState())
}
