// DailyView.swift — Situational du'as by category (expandable grid)

import SwiftUI

struct DailyView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText: String = ""

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var filteredCategories: [DailyCategory] {
        if searchText.isEmpty { return appState.dailyCategories }
        let query = searchText.lowercased()
        return appState.dailyCategories.filter { group in
            // Search in group title
            if group.category.displayName.lowercased().contains(query) { return true }
            // Search inside du'as
            return group.adhkar.contains { dhikr in
                dhikr.arabic.contains(query) ||
                dhikr.transliteration.lowercased().contains(query) ||
                dhikr.translation.lowercased().contains(query)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.appBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // Page header
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                HStack(spacing: 0) {
                                    Text("Daily")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.primaryGreen)
                                    Text(" Adhkar")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.textPrimary)
                                }
                                Spacer()
                                
                                // Grid Edit (reordering categories)
                                Button {
                                    withAnimation(.spring()) {
                                        appState.isDailyGridEditMode.toggle()
                                    }
                                } label: {
                                    Image(systemName: appState.isDailyGridEditMode ? "checkmark.circle.fill" : "slider.horizontal.3")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(appState.isDailyGridEditMode ? .white : .textPrimary)
                                        .frame(width: 36, height: 36)
                                        .background(appState.isDailyGridEditMode ? Color.primaryGreen : Color.cardBackground)
                                        .cornerRadius(10)
                                        .cardShadow()
                                }
                            }
                            Text("Situational du'as for everyday life")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                        // Search Bar
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 15))
                            TextField("Search situational categories...", text: $searchText)
                                .font(.system(size: 15))
                                .foregroundColor(.textPrimary)
                            if !searchText.isEmpty {
                                Button { searchText = "" } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.md)
                        .cardShadow()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)

                        if appState.isDailyGridEditMode {
                            // Reorder Categories List
                            VStack(spacing: 12) {
                                ForEach(appState.dailyCategories) { group in
                                    HStack {
                                        Text(group.category.emoji)
                                            .font(.system(size: 24))
                                        Text(group.category.displayName)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.textPrimary)
                                        Spacer()
                                        Image(systemName: "line.3.horizontal")
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding()
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .cardShadow()
                                }
                                .onMove { from, to in
                                    appState.moveDailyCategory(from: from, to: to)
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            // Bottom spacer for floating nav pill
                            Color.clear.frame(height: 120)
                        } else {
                            // Category grid
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(filteredCategories) { group in
                                    NavigationLink(value: group.category) {
                                        DailyCategoryCard(
                                            category: group.category,
                                            count: group.adhkar.count
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            // Bottom spacer for floating nav pill
                            Color.clear.frame(height: 120)
                        }
                    }
                }
            }
            .navigationDestination(for: AdhkarCategory.self) { category in
                DailyCategoryDetailView(category: category)
            }
            .navigationBarHidden(true) 
        }
    }
}

// MARK: - Category Card (grid item)
struct DailyCategoryCard: View {
    let category: AdhkarCategory
    let count: Int

    var body: some View {
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
}

// MARK: - Category Detail
struct DailyCategoryDetailView: View {
    @EnvironmentObject var appState: AppState
    let category: AdhkarCategory
    
    private var adhkar: [Dhikr] {
        appState.dailyCategories.first(where: { $0.category == category })?.adhkar ?? []
    }
    
    private var isListEmpty: Bool { adhkar.isEmpty }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header space
                Color.clear.frame(height: 10)

                if isListEmpty {
                    VStack(spacing: 12) {
                        Text("🕌")
                            .font(.system(size: 48))
                        Text("Coming soon")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                    Spacer()
                } else {
                    List {
                        Section {
                            ForEach(adhkar) { dhikr in
                                if dhikr.isVisible || appState.isDailyEditMode {
                                    DhikrCardView(
                                        dhikr: dhikr,
                                        isEditMode: appState.isDailyEditMode,
                                        showCounter: false,
                                        onIncrement: {},
                                        onToggleVisibility: {
                                            withAnimation(.spring()) {
                                                appState.toggleDailyVisibility(category: category, id: dhikr.id)
                                            }
                                        },
                                        onReset: {}
                                    )
                                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                }
                            }
                            .onMove { from, to in
                                appState.moveDailyAdhkar(category: category, from: from, to: to)
                            }
                        }
                        
                        // Bottom spacer
                        Color.clear.frame(height: 100)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, .constant(appState.isDailyEditMode ? .active : .inactive))
                }
            }
        }
        .navigationTitle(category.emoji + " " + category.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring()) {
                        appState.isDailyEditMode.toggle()
                    }
                } label: {
                    Image(systemName: appState.isDailyEditMode ? "checkmark.circle.fill" : "pencil.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.primaryGreen)
                }
            }
        }
        .onDisappear {
            appState.isDailyEditMode = false
        }
    }
}

#Preview {
    DailyView()
        .environmentObject(AppState())
}
