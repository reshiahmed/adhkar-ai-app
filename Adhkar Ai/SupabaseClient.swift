// SupabaseClient.swift — REST-based Supabase API client for Auth and Data Sync

import Foundation
import Combine

class SupabaseClient {
    static let shared = SupabaseClient()
    
    private let baseURL = URL(string: SupabaseConfig.url)!
    private let anonKey = SupabaseConfig.anonKey
    
    @Published var currentUser: UserProfile?
    private(set) var sessionToken: String?
    
    struct UserProfile: Codable {
        let id: UUID
        let email: String
    }
    
    private init() {
        // Automatically check for saved session on init
        if let savedToken = UserDefaults.standard.string(forKey: "supabase.session_token"),
           let savedUser = try? UserDefaults.standard.data(forKey: "supabase.user").flatMap({ try JSONDecoder().decode(UserProfile.self, from: $0) }) {
            self.sessionToken = savedToken
            self.currentUser = savedUser
        }
    }
    
    // MARK: - Auth
    
    func signIn(email: String, password: String) async throws -> UserProfile {
        let url = baseURL.appendingPathComponent("auth/v1/token").appending(queryItems: [URLQueryItem(name: "grant_type", value: "password")])
        let body = ["email": email, "password": password]
        let data = try await post(url: url, body: body, useAnon: true)
        
        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
        try saveSession(response)
        return response.user
    }
    
    func signUp(email: String, password: String) async throws -> UserProfile {
        let url = baseURL.appendingPathComponent("auth/v1/signup")
        let body = ["email": email, "password": password]
        let data = try await post(url: url, body: body, useAnon: true)
        
        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
        try saveSession(response)
        return response.user
    }
    
    func signInWithIdToken(idToken: String, nonce: String? = nil, provider: String = "apple") async throws -> UserProfile {
        let url = baseURL.appendingPathComponent("auth/v1/token").appending(queryItems: [URLQueryItem(name: "grant_type", value: "id_token")])
        let body = IDTokenBody(provider: provider, idToken: idToken, nonce: nonce)
        let data = try await post(url: url, body: body, useAnon: true)
        
        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
        try saveSession(response)
        return response.user
    }

    func updateUserMetadata(metadata: [String: String]) async throws {
        let url = baseURL.appendingPathComponent("auth/v1/user")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(anonKey, forHTTPHeaderField: "apikey")
        if let token = sessionToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body = MetadataBody(data: metadata)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("❌ Supabase updateUserMetadata failed: \(String(data: data, encoding: .utf8) ?? "unknown")")
            throw NetworkError.requestFailed(data: data)
        }
    }
    
    func signOut() {
        currentUser = nil
        sessionToken = nil
        UserDefaults.standard.removeObject(forKey: "supabase.session_token")
        UserDefaults.standard.removeObject(forKey: "supabase.user")
    }
    
    // MARK: - Database (Progress)
    
    func fetchUserProgress() async throws -> [RawUserProgress] {
        guard let userId = currentUser?.id else { throw AuthError.notAuthenticated }
        let url = baseURL.appendingPathComponent("rest/v1/user_progress").appending(queryItems: [
            URLQueryItem(name: "user_id", value: "eq.\(userId.uuidString.lowercased())")
        ])
        let data = try await get(url: url)
        return try JSONDecoder().decode([RawUserProgress].self, from: data)
    }
    
    func upsertUserProgress(_ progress: [RawUserProgress]) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/user_progress")
        _ = try await post(url: url, body: progress, upsert: true)
    }
    
    func fetchUserStats() async throws -> RawUserStats? {
        guard let userId = currentUser?.id else { throw AuthError.notAuthenticated }
        let url = baseURL.appendingPathComponent("rest/v1/user_stats").appending(queryItems: [
            URLQueryItem(name: "user_id", value: "eq.\(userId.uuidString.lowercased())")
        ])
        let data = try await get(url: url)
        let stats = try JSONDecoder().decode([RawUserStats].self, from: data)
        return stats.first
    }
    
    func upsertUserStats(_ stats: RawUserStats) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/user_stats")
        _ = try await post(url: url, body: [stats], upsert: true)
    }
    
    // MARK: - Custom Adhkar
    
    func fetchCustomAdhkar() async throws -> [RawCustomAdhkar] {
        guard let userId = currentUser?.id else { throw AuthError.notAuthenticated }
        let url = baseURL.appendingPathComponent("rest/v1/custom_adhkar").appending(queryItems: [
            URLQueryItem(name: "user_id", value: "eq.\(userId.uuidString.lowercased())")
        ])
        let data = try await get(url: url)
        return try JSONDecoder().decode([RawCustomAdhkar].self, from: data)
    }
    
    func upsertCustomAdhkar(_ adhkar: [RawCustomAdhkar]) async throws {
        let url = baseURL.appendingPathComponent("rest/v1/custom_adhkar")
        _ = try await post(url: url, body: adhkar, upsert: true)
    }

    func deleteCustomAdhkar(id: String) async throws {
        guard let userId = currentUser?.id else { throw AuthError.notAuthenticated }
        let url = baseURL.appendingPathComponent("rest/v1/custom_adhkar").appending(queryItems: [
            URLQueryItem(name: "user_id", value: "eq.\(userId.uuidString.lowercased())"),
            URLQueryItem(name: "id", value: "eq.\(id)")
        ])
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(anonKey, forHTTPHeaderField: "apikey")
        if let token = sessionToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(data: Data())
        }
    }
    
    // MARK: - Networking Helpers
    
    private func get(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(anonKey, forHTTPHeaderField: "apikey")
        if let token = sessionToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(data: data)
        }
        return data
    }
    
    private func post<T: Encodable>(url: URL, body: T, useAnon: Bool = false, upsert: Bool = false) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(anonKey, forHTTPHeaderField: "apikey")
        if upsert {
            request.addValue("resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
        }
        if let token = sessionToken, !useAnon {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("❌ Supabase POST failed: \(String(data: data, encoding: .utf8) ?? "unknown")")
            throw NetworkError.requestFailed(data: data)
        }
        return data
    }
    
    private func saveSession(_ response: AuthResponse) throws {
        self.sessionToken = response.accessToken
        self.currentUser = response.user
        UserDefaults.standard.set(response.accessToken, forTopic: "supabase.session_token")
        let userData = try JSONEncoder().encode(response.user)
        UserDefaults.standard.set(userData, forTopic: "supabase.user")
    }
}

// MARK: - Models

struct AuthResponse: Codable {
    let accessToken: String
    let tokenType: String
    let user: SupabaseClient.UserProfile
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user
    }
}

struct IDTokenBody: Encodable {
    let provider: String
    let idToken: String
    let nonce: String?
    
    enum CodingKeys: String, CodingKey {
        case provider
        case idToken = "id_token"
        case nonce
    }
}

struct MetadataBody: Encodable {
    let data: [String: String]
}

struct RawUserProgress: Codable {
    let user_id: UUID
    let adhkar_id: String
    let count: Int
    let level: String
    let last_updated: String // YYYY-MM-DD
    let next_review: String // YYYY-MM-DD
    let streak: Int
}

struct RawUserStats: Codable {
    let user_id: UUID
    let daily_count: Int
    let daily_streak: Int
    let last_active_date: String // YYYY-MM-DD
    let activity_history: String // JSON string for activity history
    let total_days_active: Int
    let longest_streak: Int
}

struct RawCustomAdhkar: Codable {
    let id: String
    let user_id: UUID
    let arabic: String
    let transliteration: String?
    let translation: String?
    let benefit: String?
    let pin_to: String?
    let source: String?
}

enum AuthError: Error {
    case notAuthenticated
}

enum NetworkError: Error {
    case requestFailed(data: Data)
}

extension UserDefaults {
    func set(_ value: Any?, forTopic key: String) {
        set(value, forKey: key)
    }
}
