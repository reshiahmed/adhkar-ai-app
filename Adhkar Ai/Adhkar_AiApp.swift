// Adhkar_AiApp.swift — App entry: AppState injection, badge clearing, scene lifecycle

import SwiftUI
import UserNotifications

@main
struct Adhkar_AiApp: App {
    @StateObject private var appState = AppState()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(appState.colorScheme)
                .onAppear {
                    appState.clearBadge()
                    appState.checkAutoReset()
                }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                appState.clearBadge()
                appState.checkAutoReset()
            case .background:
                appState.rescheduleNotifications()
            default:
                break
            }
        }
    }
}
