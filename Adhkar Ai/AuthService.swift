// AuthService.swift — Orchestrates Apple login and Supabase authentication

import Foundation

class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    /// Coordinates the native Apple login and then signs in to Supabase.
    /// - Returns: The authenticated Supabase UserProfile.
    func signInWithApple() async throws -> SupabaseClient.UserProfile {
        return try await withCheckedThrowingContinuation { continuation in
            AppleSignInManager.shared.startSignInWithApple { result in
                switch result {
                case .success(let authResult):
                    Task {
                        do {
                            // 1. Sign in to Supabase with the ID Token
                            print("ℹ️ AuthService: Signing in to Supabase with ID Token...")
                            let userProfile = try await SupabaseClient.shared.signInWithIdToken(
                                idToken: authResult.idToken,
                                nonce: authResult.nonce
                            )
                            
                            // 2. Handle first-time user details extraction
                            // Note: Apple only returns fullName/email on the VERY FIRST login.
                            if let name = authResult.fullName {
                                var metadata: [String: String] = [:]
                                let fullName = [name.givenName, name.familyName]
                                    .compactMap { $0 }
                                    .joined(separator: " ")
                                
                                if !fullName.isEmpty {
                                    metadata["full_name"] = fullName
                                }
                                if let givenName = name.givenName {
                                    metadata["given_name"] = givenName
                                }
                                if let familyName = name.familyName {
                                    metadata["family_name"] = familyName
                                }
                                
                                if !metadata.isEmpty {
                                    print("ℹ️ AuthService: Syncing first-time user metadata to Supabase [\(fullName)]")
                                    // Non-blocking update
                                    try? await SupabaseClient.shared.updateUserMetadata(metadata: metadata)
                                }
                            }
                            
                            continuation.resume(returning: userProfile)
                        } catch {
                            print("❌ AuthService: Supabase integration failed - \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                        }
                    }
                    
                case .failure(let error):
                    // Bubble up the error (e.g., cancellation or token failure)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
