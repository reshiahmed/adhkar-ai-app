// EveningView.swift — Evening Adhkar screen (mirrors Morning with evening data)

import SwiftUI

struct EveningView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText: String = ""
    @State private var showResetConfirm: Bool = false

    private var filteredAdhkar: [Dhikr] {
        let visible = appState.eveningAdhkar.filter {
            appState.isEveningEditMode ? true : $0.isVisible
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

            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 64)

                    // Page header
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 0) {
                                    Text("Evening")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.primaryGreen)
                                    Text(" Adhkar")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.textPrimary)
                                }
                                Text("Authentic Sunnah adhkar for the evening")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }

                            Spacer()

                            HStack(spacing: 10) {
                                Button {
                                    withAnimation(.easeInOut) {
                                        appState.isEveningEditMode.toggle()
                                    }
                                } label: {
                                    Image(systemName: appState.isEveningEditMode ? "checkmark" : "pencil")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(appState.isEveningEditMode ? .white : .textPrimary)
                                        .frame(width: 36, height: 36)
                                        .background(appState.isEveningEditMode ? Color.primaryGreen : Color.cardBackground)
                                        .cornerRadius(10)
                                        .cardShadow()
                                }

                                ProgressBadgeView(
                                    current: appState.eveningCompleted,
                                    total: appState.eveningTotal
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 16)

                        // Search bar
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 15))
                            TextField("Search evening adhkar...", text: $searchText)
                                .font(.system(size: 15))
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

                    // Section header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Evening Adhkar")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            Text("\(appState.eveningTotal) adhkar · \(appState.eveningCompleted) done")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                        }
                        Spacer()
                        Text("\(appState.eveningCompleted)/\(appState.eveningTotal)")
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

                    // Edit mode banner
                    if appState.isEveningEditMode {
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

                    // Adhkar list
                    LazyVStack(spacing: 12) {
                        ForEach(filteredAdhkar) { dhikr in
                            DhikrCardView(
                                dhikr: dhikr,
                                isEditMode: appState.isEveningEditMode,
                                onIncrement: { appState.incrementEvening(id: dhikr.id) },
                                onToggleVisibility: { appState.toggleEveningVisibility(id: dhikr.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut, value: appState.isEveningEditMode)

                    Button {
                        showResetConfirm = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Evening Adhkar")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .padding(.vertical, 12)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
        }
        .confirmationDialog("Reset evening adhkar progress?", isPresented: $showResetConfirm, titleVisibility: .visible) {
            Button("Reset", role: .destructive) { appState.resetEvening() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    EveningView()
        .environmentObject(AppState())
}
