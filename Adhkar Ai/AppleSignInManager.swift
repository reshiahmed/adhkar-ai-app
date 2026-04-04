// AppleSignInManager.swift — Handles native Apple ID authentication flow

import Foundation
import AuthenticationServices
import CryptoKit
import UIKit

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleSignInManager()
    
    private var currentNonce: String?
    private var completion: ((Result<AppleAuthResult, Error>) -> Void)?
    
    struct AppleAuthResult {
        let idToken: String
        let nonce: String
        let fullName: PersonNameComponents?
        let email: String?
    }
    
    private override init() {
        super.init()
    }
    
    func startSignInWithApple(completion: @escaping (Result<AppleAuthResult, Error>) -> Void) {
        self.completion = completion
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                print("❌ Apple Login: No nonce found")
                completion?(.failure(AppleSignInError.noNonce))
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("❌ Apple Login: No identity token returned")
                completion?(.failure(AppleSignInError.noToken))
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("❌ Apple Login: Token conversion failed")
                completion?(.failure(AppleSignInError.tokenConversionFailed))
                return
            }
            
            print("✅ Apple Login: Success extracting token")
            let result = AppleAuthResult(
                idToken: idTokenString,
                nonce: nonce,
                fullName: appleIDCredential.fullName,
                email: appleIDCredential.email
            )
            completion?(.success(result))
        } else {
            print("❌ Apple Login: Invalid credential type")
            completion?(.failure(AppleSignInError.invalidCredential))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let authError = error as? ASAuthorizationError, authError.code == .canceled {
            print("ℹ️ Apple Login: User cancelled")
        } else {
            print("❌ Apple Login: Error - \(error.localizedDescription)")
        }
        completion?(.failure(error))
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene ?? 
                          scenes.first { $0.activationState == .foregroundInactive } as? UIWindowScene ??
                          scenes.first as? UIWindowScene
        
        if let windowScene = windowScene {
            let window = windowScene.windows.first { $0.isKeyWindow } ?? windowScene.windows.first
            return window ?? UIWindow(windowScene: windowScene)
        }
        
        // This absolute fallback is only reached if the app has no active scene,
        // which should not happen during an interactive sign-in flow.
        // We'll try to find any window from any connected scene to avoid the deprecated init().
        for scene in scenes {
            if let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first {
                return window
            }
        }
        
        fatalError("ASPresentationAnchor requires a window scene which was not found.")
    }
    
    // MARK: - Helpers
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

enum AppleSignInError: Error, LocalizedError {
    case noNonce
    case noToken
    case tokenConversionFailed
    case invalidCredential
    
    var errorDescription: String? {
        switch self {
        case .noNonce: return "Internal error: Nonce not found."
        case .noToken: return "Apple did not return an identity token."
        case .tokenConversionFailed: return "Could not convert identity token to string."
        case .invalidCredential: return "Invalid Apple ID credential."
        }
    }
}
