// LoginView.swift — Matches the PWA login screen exactly

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            // Background gradient — lavender-blue from the PWA
            LinearGradient(
                colors: [Color(hex: "C8DCF5"), Color(hex: "D8E8F7"), Color(hex: "E8EFF8")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Card
                VStack(spacing: 24) {

                    // Logo
                    AppLogoView(size: 80)

                    // Title
                    VStack(spacing: 6) {
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                        Text("Sign in to sync your Adhkar progress")
                            .font(.system(size: 15))
                            .foregroundColor(.textSecondary)
                    }

                    // Fields
                    VStack(spacing: 14) {
                        LoginField(label: "Email", placeholder: "", text: $email, isSecure: false)
                        LoginField(label: "Password", placeholder: "", text: $password, isSecure: true)
                    }

                    // Sign In button
                    Button {
                        // TODO: Supabase auth
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.primaryGreen)
                            .cornerRadius(AppRadius.md)
                    }

                    // Sign Up link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                        Button("Sign Up") {}
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primaryGreen)
                    }

                    Divider()
                        .padding(.horizontal, -4)

                    // Offline / Dev Mode
                    VStack(spacing: 8) {
                        Button {
                            withAnimation(.easeInOut) {
                                appState.loginOffline()
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 13))
                                Text("Work Offline (Dev Mode)")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.appBackground)
                            .cornerRadius(AppRadius.sm)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.sm)
                                    .stroke(Color.divider, lineWidth: 1)
                            )
                        }

                        Text("Bypass Supabase Auth if egress is full.")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(24)
                .background(Color.cardBackground)
                .cornerRadius(AppRadius.lg)
                .cardShadow()
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }
}

// MARK: - Login Field
struct LoginField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
            }
            .frame(height: 48)
            .padding(.horizontal, 14)
            .background(Color.appBackground)
            .cornerRadius(AppRadius.sm)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
