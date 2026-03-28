// PersistenceManager.swift — UserDefaults-backed persistence for adhkar state

import Foundation
import Combine

/// Handles saving and loading adhkar progress, visibility, and settings to UserDefaults.
class PersistenceManager {

    static let shared = PersistenceManager()
    private init() {}

    private let defaults = UserDefaults.standard

    // MARK: - Keys
    private enum Key {
        static let morningCounts      = "morning_counts"       // [String: Int]
        static let eveningCounts      = "evening_counts"       // [String: Int]
        static let morningVisibility  = "morning_visibility"   // [String: Bool]
        static let eveningVisibility  = "evening_visibility"   // [String: Bool]
        static let lastMorningReset   = "last_morning_reset"   // Date
        static let lastEveningReset   = "last_evening_reset"   // Date
        static let customDhikr        = "custom_dhikr"         // [Data] (Codable)
        static let themeMode          = "theme_mode"           // String
        static let streakCount        = "streak_count"         // Int
        static let lastCompletedDay   = "last_completed_day"   // Date
        static let notificationsOn    = "notifications_on"     // Bool
        static let morningNotifHour   = "morning_notif_hour"   // Int
        static let morningNotifMin    = "morning_notif_min"    // Int
        static let eveningNotifHour   = "evening_notif_hour"   // Int
        static let eveningNotifMin    = "evening_notif_min"    // Int
    }

    // MARK: - Save / Load counts
    func saveCounts(_ counts: [UUID: Int], forKey key: String) {
        let stringKeyed = Dictionary(uniqueKeysWithValues: counts.map { (k, v) in (k.uuidString, v) })
        defaults.set(stringKeyed, forKey: key)
    }

    func loadCounts(forKey key: String) -> [UUID: Int] {
        guard let raw = defaults.dictionary(forKey: key) as? [String: Int] else { return [:] }
        return Dictionary(uniqueKeysWithValues: raw.compactMap { (k, v) in
            UUID(uuidString: k).map { ($0, v) }
        })
    }

    func saveMorningCounts(_ counts: [UUID: Int]) { saveCounts(counts, forKey: Key.morningCounts) }
    func loadMorningCounts() -> [UUID: Int] { loadCounts(forKey: Key.morningCounts) }

    func saveEveningCounts(_ counts: [UUID: Int]) { saveCounts(counts, forKey: Key.eveningCounts) }
    func loadEveningCounts() -> [UUID: Int] { loadCounts(forKey: Key.eveningCounts) }

    // MARK: - Save / Load visibility
    func saveVisibility(_ vis: [UUID: Bool], forKey key: String) {
        let stringKeyed = Dictionary(uniqueKeysWithValues: vis.map { (k, v) in (k.uuidString, v) })
        defaults.set(stringKeyed, forKey: key)
    }

    func loadVisibility(forKey key: String) -> [UUID: Bool] {
        guard let raw = defaults.dictionary(forKey: key) as? [String: Bool] else { return [:] }
        return Dictionary(uniqueKeysWithValues: raw.compactMap { (k, v) in
            UUID(uuidString: k).map { ($0, v) }
        })
    }

    func saveMorningVisibility(_ vis: [UUID: Bool]) { saveVisibility(vis, forKey: Key.morningVisibility) }
    func loadMorningVisibility() -> [UUID: Bool] { loadVisibility(forKey: Key.morningVisibility) }

    func saveEveningVisibility(_ vis: [UUID: Bool]) { saveVisibility(vis, forKey: Key.eveningVisibility) }
    func loadEveningVisibility() -> [UUID: Bool] { loadVisibility(forKey: Key.eveningVisibility) }

    // MARK: - Reset timestamps (auto-reset logic)
    var lastMorningReset: Date {
        get { defaults.object(forKey: Key.lastMorningReset) as? Date ?? .distantPast }
        set { defaults.set(newValue, forKey: Key.lastMorningReset) }
    }

    var lastEveningReset: Date {
        get { defaults.object(forKey: Key.lastEveningReset) as? Date ?? .distantPast }
        set { defaults.set(newValue, forKey: Key.lastEveningReset) }
    }

    /// Returns true if morning adhkar should be auto-reset (new calendar day)
    func shouldResetMorning() -> Bool {
        !Calendar.current.isDateInToday(lastMorningReset)
    }

    /// Returns true if evening adhkar should be auto-reset (new calendar day)
    func shouldResetEvening() -> Bool {
        !Calendar.current.isDateInToday(lastEveningReset)
    }

    // MARK: - Custom Dhikr
    func saveCustomDhikr(_ dhikr: [Dhikr]) {
        if let data = try? JSONEncoder().encode(dhikr) {
            defaults.set(data, forKey: Key.customDhikr)
        }
    }

    func loadCustomDhikr() -> [Dhikr] {
        guard let data = defaults.data(forKey: Key.customDhikr),
              let dhikr = try? JSONDecoder().decode([Dhikr].self, from: data) else { return [] }
        return dhikr
    }

    // MARK: - Theme
    var themeMode: String {
        get { defaults.string(forKey: Key.themeMode) ?? ThemeMode.auto.rawValue }
        set { defaults.set(newValue, forKey: Key.themeMode) }
    }

    // MARK: - Streak
    var streakCount: Int {
        get { defaults.integer(forKey: Key.streakCount) }
        set { defaults.set(newValue, forKey: Key.streakCount) }
    }

    var lastCompletedDay: Date? {
        get { defaults.object(forKey: Key.lastCompletedDay) as? Date }
        set { defaults.set(newValue, forKey: Key.lastCompletedDay) }
    }

    func updateStreak(completed: Bool) {
        guard completed else { return }
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastCompletedDay {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 {
                streakCount += 1   // consecutive day
            } else if diff > 1 {
                streakCount = 1    // broke streak
            }
            // diff == 0: same day, no change
        } else {
            streakCount = 1        // first ever completion
        }
        lastCompletedDay = today
    }

    // MARK: - Notification settings
    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Key.notificationsOn) }
        set { defaults.set(newValue, forKey: Key.notificationsOn) }
    }

    var morningNotifTime: DateComponents {
        get {
            var c = DateComponents()
            c.hour   = defaults.object(forKey: Key.morningNotifHour) != nil ? defaults.integer(forKey: Key.morningNotifHour) : 6
            c.minute = defaults.object(forKey: Key.morningNotifMin)  != nil ? defaults.integer(forKey: Key.morningNotifMin)  : 0
            return c
        }
        set {
            defaults.set(newValue.hour   ?? 6, forKey: Key.morningNotifHour)
            defaults.set(newValue.minute ?? 0, forKey: Key.morningNotifMin)
        }
    }

    var eveningNotifTime: DateComponents {
        get {
            var c = DateComponents()
            c.hour   = defaults.object(forKey: Key.eveningNotifHour) != nil ? defaults.integer(forKey: Key.eveningNotifHour) : 18
            c.minute = defaults.object(forKey: Key.eveningNotifMin)  != nil ? defaults.integer(forKey: Key.eveningNotifMin)  : 0
            return c
        }
        set {
            defaults.set(newValue.hour   ?? 18, forKey: Key.eveningNotifHour)
            defaults.set(newValue.minute ??  0, forKey: Key.eveningNotifMin)
        }
    }
}
