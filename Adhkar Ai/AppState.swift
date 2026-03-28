// AppState.swift — Central state management with persistence + notifications

import SwiftUI
import Combine

class AppState: ObservableObject {

    private let persistence = PersistenceManager.shared
    private let notifications = NotificationManager.shared

    // MARK: - Auth
    @Published var isLoggedIn: Bool = false
    @Published var isOfflineMode: Bool = false
    @Published var currentUser: User = User(name: "Offline Explorer", email: "offline@adhkar.ai", isOffline: true)

    // MARK: - Theme
    @Published var themeMode: ThemeMode = .auto {
        didSet { persistence.themeMode = themeMode.rawValue }
    }

    var colorScheme: ColorScheme? {
        switch themeMode {
        case .light: return .light
        case .dark:  return .dark
        case .auto:  return nil
        }
    }

    // MARK: - Morning Adhkar
    @Published var morningAdhkar: [Dhikr] = [] {
        didSet { persistMorning() }
    }
    var morningCompleted: Int { morningAdhkar.filter(\.isCompleted).count }
    var morningTotal:     Int { morningAdhkar.filter(\.isVisible).count }
    var morningAllDone:   Bool { morningCompleted >= morningTotal && morningTotal > 0 }

    // MARK: - Evening Adhkar
    @Published var eveningAdhkar: [Dhikr] = [] {
        didSet { persistEvening() }
    }
    var eveningCompleted: Int { eveningAdhkar.filter(\.isCompleted).count }
    var eveningTotal:     Int { eveningAdhkar.filter(\.isVisible).count }
    var eveningAllDone:   Bool { eveningCompleted >= eveningTotal && eveningTotal > 0 }

    // MARK: - Daily
    @Published var dailyCategories: [DailyCategory] = AdhkarData.dailyCategories.map { cat in
        DailyCategory(category: cat, adhkar: AdhkarData.adhkar(for: cat))
    }

    // MARK: - Custom Library
    @Published var customDhikr: [Dhikr] = [] {
        didSet { persistence.saveCustomDhikr(customDhikr) }
    }

    // MARK: - Edit Mode
    @Published var isMorningEditMode: Bool = false
    @Published var isEveningEditMode: Bool = false

    // MARK: - Streak
    @Published var streakCount: Int = 0

    // MARK: - Notification settings
    @Published var notificationsEnabled: Bool = false {
        didSet {
            persistence.notificationsEnabled = notificationsEnabled
            rescheduleNotifications()
        }
    }
    @Published var morningNotifTime: DateComponents = DateComponents() {
        didSet {
            persistence.morningNotifTime = morningNotifTime
            rescheduleNotifications()
        }
    }
    @Published var eveningNotifTime: DateComponents = DateComponents() {
        didSet {
            persistence.eveningNotifTime = eveningNotifTime
            rescheduleNotifications()
        }
    }
    @Published var notificationPermissionStatus: String = "unknown"  // "granted" | "denied" | "unknown"

    // MARK: - Init
    init() {
        loadPersistedState()
        checkAutoReset()
        streakCount = persistence.streakCount
    }

    // MARK: - Load
    private func loadPersistedState() {
        // Theme
        themeMode = ThemeMode(rawValue: persistence.themeMode) ?? .auto

        // Notification settings
        notificationsEnabled = persistence.notificationsEnabled
        morningNotifTime = persistence.morningNotifTime
        eveningNotifTime = persistence.eveningNotifTime

        // Morning adhkar
        var morning = AdhkarData.morning
        let mCounts = persistence.loadMorningCounts()
        let mVis    = persistence.loadMorningVisibility()
        for i in morning.indices {
            morning[i].currentCount = mCounts[morning[i].id] ?? 0
            morning[i].isVisible    = mVis[morning[i].id] ?? true
        }
        morningAdhkar = morning

        // Evening adhkar
        var evening = AdhkarData.evening
        let eCounts = persistence.loadEveningCounts()
        let eVis    = persistence.loadEveningVisibility()
        for i in evening.indices {
            evening[i].currentCount = eCounts[evening[i].id] ?? 0
            evening[i].isVisible    = eVis[evening[i].id] ?? true
        }
        eveningAdhkar = evening

        // Custom library
        customDhikr = persistence.loadCustomDhikr()
    }

    // MARK: - Auto-reset (new calendar day)
    func checkAutoReset() {
        if persistence.shouldResetMorning() {
            for i in morningAdhkar.indices { morningAdhkar[i].currentCount = 0 }
            persistence.lastMorningReset = Date()
        }
        if persistence.shouldResetEvening() {
            for i in eveningAdhkar.indices { eveningAdhkar[i].currentCount = 0 }
            persistence.lastEveningReset = Date()
        }
    }

    // MARK: - Persist helpers (debounced-style — called via didSet)
    private func persistMorning() {
        let counts = Dictionary(uniqueKeysWithValues: morningAdhkar.map { ($0.id, $0.currentCount) })
        let vis    = Dictionary(uniqueKeysWithValues: morningAdhkar.map { ($0.id, $0.isVisible) })
        persistence.saveMorningCounts(counts)
        persistence.saveMorningVisibility(vis)

        // Streak update when all morning done
        if morningAllDone {
            persistence.updateStreak(completed: true)
            streakCount = persistence.streakCount
        }
    }

    private func persistEvening() {
        let counts = Dictionary(uniqueKeysWithValues: eveningAdhkar.map { ($0.id, $0.currentCount) })
        let vis    = Dictionary(uniqueKeysWithValues: eveningAdhkar.map { ($0.id, $0.isVisible) })
        persistence.saveEveningCounts(counts)
        persistence.saveEveningVisibility(vis)
    }

    // MARK: - Manual Reset
    func resetMorning() {
        for i in morningAdhkar.indices { morningAdhkar[i].reset() }
        persistence.lastMorningReset = .distantPast   // allow re-reset today if needed
    }

    func resetEvening() {
        for i in eveningAdhkar.indices { eveningAdhkar[i].reset() }
        persistence.lastEveningReset = .distantPast
    }

    // MARK: - Increment
    func incrementMorning(id: UUID) {
        guard let i = morningAdhkar.firstIndex(where: { $0.id == id }) else { return }
        morningAdhkar[i].increment()
        triggerHaptic(completed: morningAdhkar[i].isCompleted)
    }

    func incrementEvening(id: UUID) {
        guard let i = eveningAdhkar.firstIndex(where: { $0.id == id }) else { return }
        eveningAdhkar[i].increment()
        triggerHaptic(completed: eveningAdhkar[i].isCompleted)
    }

    // MARK: - Visibility toggles
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

    // MARK: - Custom Library
    func addCustomDhikr(_ dhikr: Dhikr) {
        customDhikr.append(dhikr)
    }

    func deleteCustomDhikr(at offsets: IndexSet) {
        customDhikr.remove(atOffsets: offsets)
    }

    // MARK: - Haptics
    private func triggerHaptic(completed: Bool) {
        if completed {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    // MARK: - Notifications
    func requestNotificationPermission() {
        notifications.requestPermission { [weak self] granted in
            self?.notificationPermissionStatus = granted ? "granted" : "denied"
            if granted {
                self?.notificationsEnabled = true
                self?.rescheduleNotifications()
            }
        }
    }

    func rescheduleNotifications() {
        notifications.scheduleAll(
            morningTime: morningNotifTime,
            eveningTime: eveningNotifTime,
            enabled: notificationsEnabled
        )
    }

    func clearBadge() {
        notifications.clearBadge()
    }

    // MARK: - Auth
    func loginOffline() {
        isOfflineMode = true
        isLoggedIn = true
        currentUser = User(name: "Offline Explorer", email: "offline@adhkar.ai", isOffline: true)
        checkAutoReset()
    }

    func logout() {
        isLoggedIn = false
        isOfflineMode = false
    }
}
