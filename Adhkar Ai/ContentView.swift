// ContentView.swift — Root view: Login → Main Tab View

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.isLoggedIn {
                LoginView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingView()
                    .transition(.asymmetric(insertion: .push(from: .trailing), removal: .move(edge: .leading)))
            } else {
                MainTabView()
                    .preferredColorScheme(appState.colorScheme)
                    .overlay {
                        if appState.hasCompletedOnboarding && !appState.hasCompletedTour {
                            AppTourView(selectedTab: $appState.selectedTab)
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appState.isLoggedIn)
        .animation(.easeInOut(duration: 0.4), value: appState.hasCompletedOnboarding)
        .animation(.easeInOut(duration: 0.4), value: appState.hasCompletedTour)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .top) {
            // Page content
            TabView(selection: $appState.selectedTab) {
                MorningView()
                    .tag(0)
                EveningView()
                    .tag(1)
                DailyView()
                    .tag(2)
                MasteryView()
                    .tag(3)
                MyProgressView()
                    .tag(4)
                ProfileView()
                    .tag(5)
            }
            // Hide default tab bar so we can use our custom one
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Fixed floating header
            AppHeaderView()
                .zIndex(10)

            // Custom bottom floating navigation pill
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $appState.selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
            .zIndex(10)
        }
    }
}

// MARK: - Custom Bottom Tab Bar (Modern Floating Pill)
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @State private var isDragging: Bool = false
    
    struct TabItem: Identifiable {
        let id: Int
        let icon: String
        let label: String
    }

    let tabs: [TabItem] = [
        TabItem(id: 0, icon: "sun.min",           label: "Morning"),
        TabItem(id: 1, icon: "moon",              label: "Evening"),
        TabItem(id: 2, icon: "clock",             label: "Daily"),
        TabItem(id: 3, icon: "graduationcap",     label: "Mastery"),
        TabItem(id: 4, icon: "chart.bar",         label: "Progress"),
        TabItem(id: 5, icon: "person",            label: "Profile"),
    ]

    var body: some View {
        GeometryReader { geo in
            let itemWidth = geo.size.width / CGFloat(tabs.count)
            
            ZStack(alignment: .leading) {
                // Sliding Indicator Pill
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.primaryGreen.opacity(0.15))
                    .frame(width: itemWidth - 8, height: 54)
                    .offset(x: CGFloat(selectedTab) * itemWidth + 4, y: 8)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: selectedTab)
                
                HStack(spacing: 0) {
                    ForEach(tabs) { tab in
                        let isSelected = selectedTab == tab.id
                        
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = tab.id
                                UISelectionFeedbackGenerator().selectionChanged()
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: isSelected ? tab.icon + ".fill" : tab.icon)
                                    .font(.system(size: 19, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? .primaryGreen : .textSecondary)
                                    .frame(height: 26)
                                
                                Text(tab.label)
                                    .font(.system(size: 8, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? .primaryGreen : .textSecondary)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(width: itemWidth, height: 70)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
            }
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.12), radius: 15, x: 0, y: 8)
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        let index = Int(floor(value.location.x / itemWidth))
                        let safeIndex = max(0, min(tabs.count - 1, index))
                        
                        if selectedTab != safeIndex {
                            UISelectionFeedbackGenerator().selectionChanged()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = safeIndex
                            }
                        }
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
        .frame(height: 70)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
