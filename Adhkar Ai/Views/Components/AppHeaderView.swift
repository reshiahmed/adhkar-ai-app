// AppHeaderView.swift — Glassmorphism floating header matching the PWA exactly

import SwiftUI

struct AppHeaderView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 0) {
            // Left: Logo + wordmark
            HeaderLogoView()

            Spacer()

            // Right: Theme toggles + avatar
            HStack(spacing: 8) {
                // Theme mode picker
                ThemeToggleView()

                // Avatar circle (initials)
                ZStack {
                    Circle()
                        .fill(Color.primaryGreen)
                        .frame(width: 36, height: 36)
                    Text(appState.currentUser.avatarInitials)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .top)
                
                // Subtle hairline divider for separation only when content scrolls under
                Rectangle()
                    .fill(Color.divider.opacity(0.3))
                    .frame(height: 0.5)
            }
        )
    }
}

// MARK: - Theme Toggle
struct ThemeToggleView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ThemeMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        appState.themeMode = mode
                    }
                } label: {
                    Image(systemName: mode.icon)
                        .font(.system(size: 13, weight: .medium))
                        .frame(width: 30, height: 28)
                        .foregroundColor(appState.themeMode == mode ? .white : .textSecondary)
                        .background(
                            appState.themeMode == mode
                                ? Color.primaryGreen
                                : Color.clear
                        )
                        .cornerRadius(6)
                }
            }
        }
        .padding(3)
        .background(Color.appBackground)
        .cornerRadius(9)
        .overlay(
            RoundedRectangle(cornerRadius: 9)
                .stroke(Color.divider, lineWidth: 1)
        )
    }
}

// MARK: - Progress Badge (0/13 circle)
struct ProgressBadgeView: View {
    let current: Int
    let total: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.divider, lineWidth: 2)
            Circle()
                .trim(from: 0, to: total > 0 ? CGFloat(current) / CGFloat(total) : 0)
                .stroke(Color.primaryGreen, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: current)
            Text("\(current)/\(total)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
        .frame(width: 52, height: 52)
    }
}

#Preview {
    AppHeaderView()
        .environmentObject(AppState())
}
