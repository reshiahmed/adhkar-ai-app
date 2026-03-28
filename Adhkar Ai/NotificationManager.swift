// NotificationManager.swift — Local push notifications for morning/evening reminders

import Foundation
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()
    private init() {}

    // MARK: - Request Permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func checkPermission(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { completion(settings.authorizationStatus) }
        }
    }

    // MARK: - Schedule Notifications
    func scheduleAll(
        morningTime: DateComponents,
        eveningTime: DateComponents,
        enabled: Bool
    ) {
        cancelAll()
        guard enabled else { return }
        scheduleMorning(time: morningTime)
        scheduleEvening(time: eveningTime)
    }

    private func scheduleMorning(time: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "☀️ Morning Adhkar"
        content.body  = "Start your day with remembrance of Allah."
        content.sound = .default
        content.badge = 1

        var components = DateComponents()
        components.hour   = time.hour   ?? 6
        components.minute = time.minute ?? 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_adhkar", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    private func scheduleEvening(time: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "🌙 Evening Adhkar"
        content.body  = "Don't forget your evening adhkar before the night ends."
        content.sound = .default
        content.badge = 1

        var components = DateComponents()
        components.hour   = time.hour   ?? 18
        components.minute = time.minute ?? 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "evening_adhkar", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // MARK: - Cancel
    func cancelAll() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["morning_adhkar", "evening_adhkar"]
        )
    }

    // MARK: - Clear badge on foreground
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
    }
}
