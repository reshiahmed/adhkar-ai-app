// MorningView.swift — Morning Adhkar screen matching the PWA

import SwiftUI

struct MorningView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText: String = ""
    @State private var showResetConfirm: Bool = false

    private var filteredAdhkar: [Dhikr] {
        let visible = appState.morningAdhkar.filter {
            appState.isMorningEditMode ? true : $0.isVisible
        }
        if searchText.isEmpty { return visible }
        return visible.filter {
            $0.arabic.contains(searchText) ||
            $0.transliteration.localizedCaseInsensitiveContains(searchText) ||
            $0.translation.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    morningHeader
                    
                    if appState.morningAllDone {
                        CompletionBannerView(message: "Morning adhkar complete! 🌅")
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    if appState.showSearchBars {
                        searchBar
                    }
                    sectionHeader

                    if appState.isMorningEditMode {
                        editModeBanner
                    }

                    dhikrList
                    resetButton
                    
                    Color.clear.frame(height: 100)
                }
            }
        }
        .confirmationDialog("Reset morning adhkar progress?", isPresented: $showResetConfirm, titleVisibility: .visible) {
            Button("Reset", role: .destructive) { appState.resetMorning() }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Subviews
    private var morningHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text("Morning")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primaryGreen)
                    Text(" Adhkar")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                }
                Text("Authentic Sunnah adhkar for the morning")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            HStack(spacing: 10) {
                Button {
                    withAnimation(.easeInOut) {
                        appState.isMorningEditMode.toggle()
                    }
                } label: {
                    Image(systemName: appState.isMorningEditMode ? "checkmark" : "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(appState.isMorningEditMode ? .white : .textPrimary)
                        .frame(width: 36, height: 36)
                        .background(appState.isMorningEditMode ? Color.primaryGreen : Color.cardBackground)
                        .cornerRadius(10)
                        .cardShadow()
                }
                ProgressBadgeView(current: appState.morningCompleted, total: appState.morningTotal)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.system(size: 15))
            TextField("Search morning adhkar...", text: $searchText)
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
        .padding(.bottom, 16)
    }

    private var sectionHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Morning Adhkar")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text("\(appState.morningTotal) adhkar · \(appState.morningCompleted) done")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
            Text("\(appState.morningCompleted)/\(appState.morningTotal)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primaryGreen)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.lightGreen)
                .cornerRadius(AppRadius.full)

            Image(systemName: "chevron.up")
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    private var editModeBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.primaryGreen)
            Text("Edit mode — toggle visibility of each dhikr")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.lightGreen)
        .cornerRadius(AppRadius.sm)
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .transition(.opacity)
    }

    private var dhikrList: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredAdhkar) { dhikr in
                DhikrCardView(
                    dhikr: dhikr,
                    isEditMode: appState.isMorningEditMode,
                    onIncrement: { appState.incrementMorning(id: dhikr.id) },
                    onToggleVisibility: { appState.toggleMorningVisibility(id: dhikr.id) },
                    onReset: { appState.resetIndividualMorning(id: dhikr.id) }
                )
            }
        }
        .padding(.horizontal, 16)
    }

    private var resetButton: some View {
        Button {
            showResetConfirm = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.divider.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                
                Text("Reset Morning Adhkar Progress")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.textSecondary.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.cardBackground)
            .cornerRadius(20)
            .cardShadow()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }
}

// MARK: - Completion Banner
struct CompletionBannerView: View {
    let message: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.primaryGreen)
            Text(message)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primaryGreen)
            Spacer()
        }
        .padding(12)
        .background(Color.lightGreen)
        .cornerRadius(AppRadius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.sm)
                .stroke(Color.primaryGreen.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    MorningView()
        .environmentObject(AppState())
}
