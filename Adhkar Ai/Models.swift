// Models.swift — Data models for Adhkar AI

import Foundation
import SwiftUI

// MARK: - App Theme Mode
enum ThemeMode: String, CaseIterable {
    case light  = "light"
    case auto   = "auto"
    case dark   = "dark"

    var icon: String {
        switch self {
        case .light: return "sun.min"
        case .auto:  return "clock"
        case .dark:  return "moon"
        }
    }
}

// MARK: - Dhikr Model
struct Dhikr: Identifiable, Codable {
    var id: UUID = UUID()
    var arabic: String
    var transliteration: String
    var translation: String
    var repetitions: Int          // How many times to recite (e.g., 3, 7, 33)
    var currentCount: Int = 0
    var isVisible: Bool = true    // Visibility toggle (like the PWA edit mode)
    var source: String?           // e.g. "Bukhari", "Muslim"
    var category: AdhkarCategory

    var isCompleted: Bool { currentCount >= repetitions }
    var progress: Double { Double(currentCount) / Double(repetitions) }

    mutating func increment() {
        if currentCount < repetitions {
            currentCount += 1
        }
    }

    mutating func reset() {
        currentCount = 0
    }
}

// MARK: - Category
enum AdhkarCategory: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }

    case morning  = "morning"
    case evening  = "evening"

    // Daily situational
    case wakeUp        = "wakeUp"
    case bathroom      = "bathroom"
    case gettingDressed = "gettingDressed"
    case eating        = "eating"
    case sleeping      = "sleeping"
    case travelling    = "travelling"
    case rain          = "rain"
    case mosque        = "mosque"
    case greeting      = "greeting"
    case sneezing      = "sneezing"
    case custom        = "custom"

    var displayName: String {
        switch self {
        case .morning:         return "Morning Adhkar"
        case .evening:         return "Evening Adhkar"
        case .wakeUp:          return "After Waking Up"
        case .bathroom:        return "Entering Bathroom"
        case .gettingDressed:  return "Getting Dressed"
        case .eating:          return "Eating & Drinking"
        case .sleeping:        return "Before Sleeping"
        case .travelling:      return "Travelling"
        case .rain:            return "Rain"
        case .mosque:          return "Mosque"
        case .greeting:        return "Greetings"
        case .sneezing:        return "Sneezing"
        case .custom:          return "My Library"
        }
    }

    var emoji: String {
        switch self {
        case .morning:         return "☀️"
        case .evening:         return "🌙"
        case .wakeUp:          return "🌅"
        case .bathroom:        return "🚿"
        case .gettingDressed:  return "👕"
        case .eating:          return "🍽️"
        case .sleeping:        return "😴"
        case .travelling:      return "🚗"
        case .rain:            return "🌧️"
        case .mosque:          return "🕌"
        case .greeting:        return "👋"
        case .sneezing:        return "🤧"
        case .custom:          return "📚"
        }
    }
}

// MARK: - Daily Category Group
struct DailyCategory: Identifiable {
    var id: UUID = UUID()
    var category: AdhkarCategory
    var adhkar: [Dhikr]
    var isExpanded: Bool = false

    var completedCount: Int { adhkar.filter(\.isCompleted).count }
}

// MARK: - Mastery Progress
struct MasteryProgress: Identifiable {
    var id: UUID = UUID()
    var dhikr: Dhikr
    var memorizationLevel: Int     // 0–5 (spaced repetition level)
    var nextReviewDate: Date?
    var isDueToday: Bool {
        guard let next = nextReviewDate else { return true }
        return next <= Date()
    }
}

// MARK: - User
struct User {
    var name: String
    var email: String
    var avatarInitials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first.map(String.init) }.joined().uppercased()
    }
    var isOffline: Bool = false
}

// MARK: - Daily Progress Entry (for My Progress chart)
struct DailyProgressEntry: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var morningCompleted: Bool
    var eveningCompleted: Bool
    var completionRatio: Double // 0.0 – 1.0
}
