// ContentView.swift — Root view: Login → Main Tab View

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
                    .preferredColorScheme(appState.colorScheme)
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.isLoggedIn)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .top) {
            // Page content
            TabView(selection: $selectedTab) {
                MorningView()
                    .tag(0)
                EveningView()
                    .tag(1)
                DailyView()
                    .tag(2)
                MasteryView()
                    .tag(3)
                ProfileView()
                    .tag(4)
            }
            // Hide default tab bar so we can use our custom one
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Fixed floating header
            AppHeaderView()
                .zIndex(10)

            // Custom bottom tab bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
            .zIndex(10)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Bottom Tab Bar (matching PWA exactly)
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    struct TabItem {
        let icon: String
        let label: String
    }

    let tabs: [TabItem] = [
        TabItem(icon: "sun.min",           label: "Morning"),
        TabItem(icon: "moon",              label: "Evening"),
        TabItem(icon: "clock",             label: "Daily"),
        TabItem(icon: "graduationcap",     label: "Mastery"),
        TabItem(icon: "person",            label: "Profile"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == index ? tab.icon + ".fill" : tab.icon)
                            .font(.system(size: 20, weight: selectedTab == index ? .semibold : .regular))
                            .foregroundColor(selectedTab == index ? .primaryGreen : .textSecondary)
                            .animation(.easeInOut(duration: 0.2), value: selectedTab)

                        Text(tab.label)
                            .font(.system(size: 10, weight: selectedTab == index ? .semibold : .regular))
                            .foregroundColor(selectedTab == index ? .primaryGreen : .textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 24) // extra for home indicator
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            Color.tabBarBackground
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -2)
        )
        .overlay(Divider(), alignment: .top)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
