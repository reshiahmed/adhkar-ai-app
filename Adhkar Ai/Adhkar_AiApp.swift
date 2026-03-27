// Adhkar_AiApp.swift — App entry point with AppState injection

import SwiftUI

@main
struct Adhkar_AiApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(appState.colorScheme)
        }
    }
}
