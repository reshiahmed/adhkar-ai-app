// AppState.swift — Central state management (ObservableObject)

import SwiftUI
import Combine

class AppState: ObservableObject {

    // MARK: - Auth
    @Published var isLoggedIn: Bool = false
    @Published var isOfflineMode: Bool = false
    @Published var currentUser: User = User(name: "Offline Explorer", email: "offline@adhkar.ai", isOffline: true)

    // MARK: - Theme
    @Published var themeMode: ThemeMode = .auto

    var colorScheme: ColorScheme? {
        switch themeMode {
        case .light: return .light
        case .dark:  return .dark
        case .auto:  return nil
        }
    }

    // MARK: - Morning Adhkar
    @Published var morningAdhkar: [Dhikr] = AdhkarData.morning
    var morningCompleted: Int { morningAdhkar.filter(\.isCompleted).count }
    var morningTotal: Int { morningAdhkar.filter(\.isVisible).count }
    var morningAllDone: Bool { morningCompleted >= morningTotal && morningTotal > 0 }

    // MARK: - Evening Adhkar
    @Published var eveningAdhkar: [Dhikr] = AdhkarData.evening
    var eveningCompleted: Int { eveningAdhkar.filter(\.isCompleted).count }
    var eveningTotal: Int { eveningAdhkar.filter(\.isVisible).count }

    // MARK: - Daily
    @Published var dailyCategories: [DailyCategory] = AdhkarData.dailyCategories.map { cat in
        DailyCategory(category: cat, adhkar: AdhkarData.adhkar(for: cat))
    }

    // MARK: - Edit Mode (toggled via pencil button)
    @Published var isMorningEditMode: Bool = false
    @Published var isEveningEditMode: Bool = false

    // MARK: - Reset (daily reset at midnight)
    func resetMorning() {
        for i in morningAdhkar.indices { morningAdhkar[i].reset() }
    }

    func resetEvening() {
        for i in eveningAdhkar.indices { eveningAdhkar[i].reset() }
    }

    // MARK: - Increment dhikr
    func incrementMorning(id: UUID) {
        if let i = morningAdhkar.firstIndex(where: { $0.id == id }) {
            morningAdhkar[i].increment()
            checkHaptic(completed: morningAdhkar[i].isCompleted)
        }
    }

    func incrementEvening(id: UUID) {
        if let i = eveningAdhkar.firstIndex(where: { $0.id == id }) {
            eveningAdhkar[i].increment()
            checkHaptic(completed: eveningAdhkar[i].isCompleted)
        }
    }

    // MARK: - Toggle visibility
    func toggleMorningVisibility(id: UUID) {
        if let i = morningAdhkar.firstIndex(where: { $0.id == id }) {
            morningAdhkar[i].isVisible.toggle()
        }
    }

    func toggleEveningVisibility(id: UUID) {
        if let i = eveningAdhkar.firstIndex(where: { $0.id == id }) {
            eveningAdhkar[i].isVisible.toggle()
        }
    }

    // MARK: - Haptic
    private func checkHaptic(completed: Bool) {
        if completed {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }

    // MARK: - Login
    func loginOffline() {
        isOfflineMode = true
        isLoggedIn = true
        currentUser = User(name: "Offline Explorer", email: "offline@adhkar.ai", isOffline: true)
    }

    func logout() {
        isLoggedIn = false
        isOfflineMode = false
    }
}
