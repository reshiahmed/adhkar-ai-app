//
//  ContentView.swift
//  Adhkar Ai
//
//  Created by Ahmed Reshi on 4.04.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
                    .transition(.move(edge: .trailing))
            } else if !appState.isLoggedIn {
                LoginView()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: appState.hasCompletedOnboarding)
        .animation(.easeInOut, value: appState.isLoggedIn)
    }
}

// Placeholder for MainTabView if it doesn't exist yet, 
// but we'll check the project for the actual main dashboard.
fileprivate struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Group {
                switch appState.selectedTab {
                case 0: MorningView()
                case 1: EveningView()
                case 2: DailyView()
                case 3: MasteryView()
                case 4: MyProgressView()
                case 5: ProfileView()
                default: MorningView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Floating Nav Pill
            NavPill(selectedTab: $appState.selectedTab)
                .padding(.bottom, 34) // Adjust for safe area / home indicator
        }
        .ignoresSafeArea(.keyboard)
    }
}

fileprivate struct NavPill: View {
    @Binding var selectedTab: Int
    @Namespace private var pillNamespace

    let tabs = [
        NavTabItem(index: 0, icon: "sun.max.fill",       label: "Morning"),
        NavTabItem(index: 1, icon: "moon.stars.fill",    label: "Evening"),
        NavTabItem(index: 2, icon: "list.bullet",        label: "Daily"),
        NavTabItem(index: 3, icon: "brain.fill",         label: "Mastery"),
        NavTabItem(index: 4, icon: "chart.bar.fill",     label: "Progress"),
        NavTabItem(index: 5, icon: "person.crop.circle", label: "Profile")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                NavPillTab(
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    namespace: pillNamespace
                ) {
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.72)) {
                        selectedTab = tab.index
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 6)
        .background {
            ZStack {
                // Frosted glass base
                Capsule()
                    .fill(.ultraThinMaterial)

                // Subtle body gradient — adds depth
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.10),
                                Color.clear,
                                Color.black.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Top-edge specular line — simulates curved glass catching light
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.30), Color.clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )

                // Gradient border for rim-light realism
                Capsule()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.50),
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.75
                    )
            }
        }
        // Multi-layer depth shadow
        .shadow(color: .black.opacity(0.10), radius: 24, x: 0, y: 10)
        .shadow(color: .black.opacity(0.06), radius: 6,  x: 0, y: 3)
        .shadow(color: Color.primaryGreen.opacity(0.10), radius: 18, x: 0, y: 5)
        .padding(.horizontal, 16)
    }
}

fileprivate struct NavPillTab: View {
    let tab: NavTabItem
    let isSelected: Bool
    var namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Liquid glass sliding indicator
                if isSelected {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.primaryGreen.opacity(0.88),
                                    Color.primaryGreen
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        // Glass shine — top-left specular highlight
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.38), Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                )
                                .blendMode(.overlay)
                        }
                        // Rim highlight
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.45),
                                            Color.white.opacity(0.10)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.6
                                )
                        }
                        // Green glow beneath
                        .shadow(color: Color.primaryGreen.opacity(0.45), radius: 12, x: 0, y: 5)
                        .shadow(color: Color.primaryGreen.opacity(0.20), radius: 4,  x: 0, y: 2)
                        .matchedGeometryEffect(id: "liquidBlob", in: namespace)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .overlay {
                VStack(spacing: 3) {
                    Image(systemName: tab.icon)
                        .font(.system(
                            size: isSelected ? 19 : 17,
                            weight: isSelected ? .bold : .medium
                        ))
                        .scaleEffect(isSelected ? 1.08 : 1.0)
                        .animation(
                            .spring(response: 0.35, dampingFraction: 0.65),
                            value: isSelected
                        )

                    if isSelected {
                        Text(tab.label)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .opacity
                                )
                            )
                    }
                }
                .foregroundStyle(isSelected ? .white : Color.textSecondary)
                .animation(.spring(response: 0.35, dampingFraction: 0.70), value: isSelected)
            }
        }
        .buttonStyle(.plain)
    }
}

struct NavTabItem: Identifiable {
    let id = UUID()
    let index: Int
    let icon: String
    let label: String
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
