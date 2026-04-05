// LoginView.swift — Unified Auth screen for Login, Signup, and Password Reset

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    enum AuthMode {
        case login
        case signup
        case forgotPassword
    }
    
    @State private var mode: AuthMode = .login
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var name: String = ""
    @State private var isLoading: Bool = false
    @State private var alertMessage: String?
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 28) {
                    Spacer(minLength: 20)

                    // Logo
                    Image("WelcomeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .cornerRadius(22)

                    // Title & Description
                    VStack(spacing: 8) {
                        Text(titleText)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                        Text(subtitleText)
                            .font(.system(size: 15))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Input Form
                    VStack(spacing: 16) {
                        if mode == .signup {
                            LoginField(label: "Full Name", placeholder: "e.g. Abdullah", text: $name, isSecure: false)
                        }
                        
                        LoginField(label: "Email Address", placeholder: "name@example.com", text: $email, isSecure: false)
                        
                        if mode != .forgotPassword {
                            VStack(alignment: .trailing, spacing: 6) {
                                LoginField(label: "Password", placeholder: "••••••••", text: $password, isSecure: true)
                                
                                if mode == .login {
                                    Button("Forgot Password?") {
                                        withAnimation(.spring()) { mode = .forgotPassword }
                                    }
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primaryGreen)
                                    .padding(.trailing, 4)
                                }
                            }
                        }
                        
                        if mode == .signup {
                            LoginField(label: "Confirm Password", placeholder: "••••••••", text: $confirmPassword, isSecure: true)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Primary Action Button
                    Button {
                        handlePrimaryAction()
                    } label: {
                        ZStack {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(primaryButtonText)
                                    .font(.system(size: 17, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.primaryGreen)
                        .cornerRadius(18)
                        .cardShadow()
                    }
                    .padding(.horizontal, 24)
                    .disabled(isLoading)

                    // Secondary Navigation
                    HStack(spacing: 6) {
                        Text(secondaryLeadText)
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                        
                        Button(secondaryActionText) {
                            withAnimation {
                                mode = (mode == .login) ? .signup : .login
                            }
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primaryGreen)
                    }
                    
                    Divider().padding(.horizontal, 40).padding(.vertical, 8)

                    // Offline/Dev Mode Bypass
                    VStack(spacing: 8) {
                        Button {
                            withAnimation { appState.loginOffline() }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Continue Offline")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .cardShadow()
                        }
                        .padding(.horizontal, 24)
                        
                        Text("No account needed for local explore.")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary.opacity(0.5))
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .alert("Auth Info", isPresented: $showAlert) {
            Button("OK") { showAlert = false }
        } message: {
            Text(alertMessage ?? "An error occurred.")
        }
    }
    
    // MARK: - Logic
    
    private var titleText: String {
        switch mode {
        case .login: return "Welcome Back"
        case .signup: return "Create Account"
        case .forgotPassword: return "Reset Password"
        }
    }
    
    private var subtitleText: String {
        switch mode {
        case .login: return "Please sign in to your account."
        case .signup: return "Join thousands of others mastering their adhkar daily."
        case .forgotPassword: return "Enter your email and we'll send you a reset link."
        }
    }
    
    private var primaryButtonText: String {
        switch mode {
        case .login: return "Sign In"
        case .signup: return "Get Started"
        case .forgotPassword: return "Send Reset Link"
        }
    }
    
    private var secondaryLeadText: String {
        mode == .login ? "Don't have an account?" : "Already have an account?"
    }
    
    private var secondaryActionText: String {
        mode == .login ? "Sign Up" : "Log In"
    }
    
    private func handlePrimaryAction() {
        guard !email.isEmpty && (mode == .forgotPassword || !password.isEmpty) else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        isLoading = true
        
        Task {
            do {
                switch mode {
                case .login:
                    try await appState.loginReal(email: email, pass: password)
                case .signup:
                    guard password == confirmPassword else {
                        throw NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match."])
                    }
                    try await appState.signupReal(email: email, pass: password)
                case .forgotPassword:
                    // TODO: Implement forgot password REST call
                    alertMessage = "Password reset instructions sent to \(email)."
                    showAlert = true
                    mode = .login
                }
                
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }

    private func handleAppleSignIn() {
        isLoading = true
        Task {
            do {
                try await appState.signInWithApple()
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    // Don't show alert for cancellation
                    if let authError = error as? ASAuthorizationError, authError.code == .canceled {
                        return
                    }
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

// MARK: - Login Field (Matching PWA rounded style)
struct LoginField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(label.contains("Email") ? .emailAddress : .default)
                        .textInputAutocapitalization(.never)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Color.appBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.divider.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
