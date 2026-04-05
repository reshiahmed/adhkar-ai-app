// ProfileView.swift — User profile, settings, library, progress

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    @State private var showLibrary = false
    @State private var showProgress = false
    @State private var showSettings = false
    @State private var showLogoutConfirm = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Profile card
                    VStack(spacing: 0) {
                        // Green banner with integrated Offline Indicator
                        ZStack(alignment: .topTrailing) {
                            Rectangle()
                                .fill(Color.primaryGreen)
                                .frame(height: 70)
                                .cornerRadius(AppRadius.md, corners: [.topLeft, .topRight])
                            
                            if appState.isOfflineMode {
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(16)
                            }
                        }

                        // Avatar + name
                        HStack(alignment: .top, spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.primaryGreen)
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.cardBackground, lineWidth: 3)
                                    )
                                Text(appState.currentUser?.avatarInitials ?? "G")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(y: -32)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(appState.currentUser?.name ?? "Guest User")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                Text(appState.currentUser?.email ?? "Sign in for sync")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.top, 8)

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .offset(y: 0)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(AppRadius.md)
                    .cardShadow()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    // App info row
                    ProfileRowItem(
                        iconImage: "AppLogoRow",
                        title: "Adhkar AI",
                        subtitle: "Your daily dhikr companion",
                        useGradientIcon: true
                    ) {}
                    // Nav Categories
                    VStack(spacing: 12) {
                        ProfileNavigationRow(
                            icon: "gearshape.fill",
                            iconColor: .primaryGreen,
                            title: "App Settings",
                            subtitle: "Arabic font size, style & visuals"
                        ) { showSettings = true }

                        ProfileNavigationRow(
                            icon: "books.vertical.fill",
                            iconColor: Color(hex: "EC4899"),
                            title: "Adhkar Library",
                            subtitle: "Sync & manage personal du'as"
                        ) { showLibrary = true }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)

                    // Developer & Account Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Account & Developer")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 16)

                        VStack(spacing: 0) {
                            // Offline Mode
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 42, height: 42)
                                    Image(systemName: "wifi.slash")
                                        .font(.system(size: 18))
                                        .foregroundColor(.textSecondary)
                                }
                                Text("Offline Mode (Dev)")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                Toggle("", isOn: $appState.isOfflineMode)
                                    .tint(.primaryGreen)
                                    .labelsHidden()
                            }
                            .padding(14)

                            Divider().padding(.leading, 64)

                            // Sign Out
                            Button {
                                showLogoutConfirm = true
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.red.opacity(0.1))
                                            .frame(width: 42, height: 42)
                                        Image(systemName: "power")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.red)
                                    }
                                    Text("Sign Out")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                            .padding(14)
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .cardShadow()
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)

                    // App Version Footer
                    VStack(spacing: 6) {
                        Text("Adhkar AI · v1.1.0")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.textSecondary)
                        Text("By Reshi Ahmed")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary.opacity(0.6))
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 120) // Spacer for floating nav
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showLibrary) {
            AdhkarLibraryView()
        }
        .sheet(isPresented: $showProgress) {
            MyProgressView()
        }
        .confirmationDialog("Sign out?", isPresented: $showLogoutConfirm) {
            Button("Sign Out", role: .destructive) { appState.logout() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Profile Row
struct ProfileRowItem: View {
    let iconImage: String
    let title: String
    let subtitle: String
    var useGradientIcon: Bool = false
    let action: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            if useGradientIcon {
                AppLogoView(size: 42)
            } else {
                Image(systemName: iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}

struct ProfileNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 42, height: 42)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(14)
            .background(Color.cardBackground)
            .cornerRadius(AppRadius.md)
            .cardShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Rounded corners helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
