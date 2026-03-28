// ProfileView.swift — User profile, settings, library, progress (v2)

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLibrary      = false
    @State private var showProgress     = false
    @State private var showSettings     = false
    @State private var showLogoutConfirm = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 64)

                    // Offline banner
                    if appState.isOfflineMode {
                        HStack(spacing: 10) {
                            Image(systemName: "wifi.slash")
                                .foregroundColor(Color(hex: "92400E"))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Offline Mode Active")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "92400E"))
                                Text("Supabase sync is disabled. Working locally.")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "92400E").opacity(0.8))
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(Color(hex: "FFF3CD"))
                        .cornerRadius(AppRadius.sm)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    }

                    // Profile card
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.primaryGreen)
                            .frame(height: 70)
                            .cornerRadius(AppRadius.md, corners: [.topLeft, .topRight])

                        HStack(alignment: .top, spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.primaryGreen)
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.cardBackground, lineWidth: 3)
                                    )
                                Text(appState.currentUser.avatarInitials)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(y: -32)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(appState.currentUser.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                Text(appState.currentUser.email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.top, 8)

                            Spacer()

                            // Streak pill
                            HStack(spacing: 4) {
                                Text("🔥")
                                    .font(.system(size: 16))
                                Text("\(appState.streakCount)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "F59E0B"))
                                Text("day streak")
                                    .font(.system(size: 12))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(hex: "FFF3CD"))
                            .cornerRadius(AppRadius.full)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                    .background(Color.cardBackground)
                    .cornerRadius(AppRadius.md)
                    .cardShadow()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    // App info row
                    HStack(spacing: 14) {
                        AppLogoView(size: 42)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Adhkar AI")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            Text("Your daily dhikr companion")
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

                    // Feature navigation rows
                    VStack(spacing: 10) {
                        ProfileNavigationRow(
                            icon: "books.vertical",
                            iconColor: Color(hex: "EC4899"),
                            title: "Adhkar Library",
                            subtitle: "Create & manage your personal du'as",
                            badge: appState.customDhikr.isEmpty ? nil : "\(appState.customDhikr.count)"
                        ) { showLibrary = true }

                        ProfileNavigationRow(
                            icon: "graduationcap",
                            iconColor: Color.primaryGreen,
                            title: "Mastery",
                            subtitle: "Track your memorization journey"
                        ) {}

                        ProfileNavigationRow(
                            icon: "chart.bar.fill",
                            iconColor: Color(hex: "3B82F6"),
                            title: "My Progress",
                            subtitle: "View daily completion stats"
                        ) { showProgress = true }

                        ProfileNavigationRow(
                            icon: "bell.fill",
                            iconColor: Color(hex: "F59E0B"),
                            title: "Notifications & Settings",
                            subtitle: appState.notificationsEnabled ? "Reminders are on" : "Tap to set up reminders"
                        ) { showSettings = true }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)

                    // Dev settings
                    VStack(spacing: 10) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.12))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 18))
                                    .foregroundColor(.textSecondary)
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Offline Mode")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                Text("Bypass Supabase auth for local testing")
                                    .font(.system(size: 12))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Toggle("", isOn: $appState.isOfflineMode)
                                .tint(.primaryGreen)
                                .labelsHidden()
                        }
                        .padding(14)
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.md)
                        .cardShadow()

                        Text("Adhkar AI · v1.0.0")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 16)

                    Button { showLogoutConfirm = true } label: {
                        Text("Sign Out")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.vertical, 12)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .sheet(isPresented: $showLibrary) {
            AdhkarLibraryView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showProgress) {
            MyProgressView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
        .confirmationDialog("Sign out?", isPresented: $showLogoutConfirm) {
            Button("Sign Out", role: .destructive) { appState.logout() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Navigation Row (updated with optional badge)
struct ProfileNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var badge: String? = nil
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
                if let badge {
                    Text(badge)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.primaryGreen)
                        .cornerRadius(AppRadius.full)
                }
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

// MARK: - Corner radius helper (keep here to avoid duplicate)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
