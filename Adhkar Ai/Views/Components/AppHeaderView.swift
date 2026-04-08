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
                    Text(appState.currentUser?.avatarInitials ?? "G")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
        )
        .overlay(alignment: .top) {
            // Light gradient to soften content as it scrolls under the header
            LinearGradient(
                colors: [Color.appBackground.opacity(0.98), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 60)
            .ignoresSafeArea(edges: .top)
            .allowsHitTesting(false)
        }
        .overlay(alignment: .bottom) {
            // Subtle hairline divider for separation only when content scrolls under
            Rectangle()
                .fill(Color.divider.opacity(0.3))
                .frame(height: 0.5)
        }
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
        .appHeaderGlassBackground(cornerRadius: 9)
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

// MARK: - Availability Helpers
private extension View {
    @ViewBuilder
    func appHeaderGlassBackground(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}

#Preview {
    AppHeaderView()
        .environmentObject(AppState())
}
