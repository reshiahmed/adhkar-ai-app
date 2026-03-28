// SettingsView.swift — Notification scheduling, theme, and app preferences

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var morningHour: Int   = 6
    @State private var morningMinute: Int = 0
    @State private var eveningHour: Int   = 18
    @State private var eveningMinute: Int = 0
    @State private var showPermissionAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // MARK: Notifications Section
                        SettingsSectionHeader(title: "Notifications", icon: "bell.fill", color: Color(hex: "F59E0B"))

                        VStack(spacing: 1) {

                            // Master toggle
                            SettingsRow {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Daily Reminders")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(.textPrimary)
                                        Text("Get reminded for morning & evening adhkar")
                                            .font(.system(size: 12))
                                            .foregroundColor(.textSecondary)
                                    }
                                    Spacer()
                                    Toggle("", isOn: Binding(
                                        get: { appState.notificationsEnabled },
                                        set: { newVal in
                                            if newVal {
                                                appState.requestNotificationPermission()
                                            } else {
                                                appState.notificationsEnabled = false
                                            }
                                        }
                                    ))
                                    .tint(.primaryGreen)
                                    .labelsHidden()
                                }
                            }

                            if appState.notificationsEnabled {
                                Divider().padding(.horizontal, 16)

                                // Morning time picker
                                SettingsRow {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Label("Morning Reminder  ☀️", systemImage: "sun.min")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.textPrimary)

                                        HStack(spacing: 0) {
                                            Picker("Hour", selection: $morningHour) {
                                                ForEach(0..<24, id: \.self) { h in
                                                    Text(String(format: "%02d", h)).tag(h)
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .frame(width: 80, height: 100)
                                            .clipped()

                                            Text(":")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.textPrimary)

                                            Picker("Minute", selection: $morningMinute) {
                                                ForEach([0, 15, 30, 45], id: \.self) { m in
                                                    Text(String(format: "%02d", m)).tag(m)
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .frame(width: 80, height: 100)
                                            .clipped()

                                            Spacer()

                                            Text(formattedTime(hour: morningHour, minute: morningMinute))
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundColor(.primaryGreen)
                                        }
                                    }
                                }

                                Divider().padding(.horizontal, 16)

                                // Evening time picker
                                SettingsRow {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Label("Evening Reminder  🌙", systemImage: "moon")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.textPrimary)

                                        HStack(spacing: 0) {
                                            Picker("Hour", selection: $eveningHour) {
                                                ForEach(0..<24, id: \.self) { h in
                                                    Text(String(format: "%02d", h)).tag(h)
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .frame(width: 80, height: 100)
                                            .clipped()

                                            Text(":")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.textPrimary)

                                            Picker("Minute", selection: $eveningMinute) {
                                                ForEach([0, 15, 30, 45], id: \.self) { m in
                                                    Text(String(format: "%02d", m)).tag(m)
                                                }
                                            }
                                            .pickerStyle(.wheel)
                                            .frame(width: 80, height: 100)
                                            .clipped()

                                            Spacer()

                                            Text(formattedTime(hour: eveningHour, minute: eveningMinute))
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundColor(.primaryGreen)
                                        }
                                    }
                                }

                                // Save button
                                Button {
                                    saveNotificationTimes()
                                } label: {
                                    Text("Save Reminder Times")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48)
                                        .background(Color.primaryGreen)
                                        .cornerRadius(AppRadius.md)
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 4)
                            }
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.md)
                        .cardShadow()

                        // MARK: Appearance section
                        SettingsSectionHeader(title: "Appearance", icon: "paintbrush.fill", color: Color(hex: "8B5CF6"))

                        VStack(spacing: 1) {
                            SettingsRow {
                                HStack {
                                    Text("Theme")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Picker("", selection: $appState.themeMode) {
                                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                                            Label(mode.rawValue.capitalized, systemImage: mode.icon)
                                                .tag(mode)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                    .frame(width: 180)
                                    .tint(.primaryGreen)
                                }
                            }
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.md)
                        .cardShadow()

                        // MARK: About
                        SettingsSectionHeader(title: "About", icon: "info.circle.fill", color: Color(hex: "3B82F6"))

                        VStack(spacing: 1) {
                            SettingsRow {
                                HStack {
                                    Text("Version")
                                        .font(.system(size: 15))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            Divider().padding(.horizontal, 16)
                            SettingsRow {
                                HStack {
                                    Text("Total Adhkar")
                                        .font(.system(size: 15))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Text("\(AdhkarData.morning.count + AdhkarData.evening.count)")
                                        .foregroundColor(.primaryGreen)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.md)
                        .cardShadow()

                        Spacer(minLength: 32)
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.primaryGreen)
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                morningHour   = appState.morningNotifTime.hour   ?? 6
                morningMinute = appState.morningNotifTime.minute ?? 0
                eveningHour   = appState.eveningNotifTime.hour   ?? 18
                eveningMinute = appState.eveningNotifTime.minute ?? 0
            }
        }
    }

    // MARK: - Helpers
    private func formattedTime(hour: Int, minute: Int) -> String {
        let h = hour % 12 == 0 ? 12 : hour % 12
        let m = String(format: "%02d", minute)
        let period = hour < 12 ? "AM" : "PM"
        return "\(h):\(m) \(period)"
    }

    private func saveNotificationTimes() {
        var morning = DateComponents(); morning.hour = morningHour; morning.minute = morningMinute
        var evening = DateComponents(); evening.hour = eveningHour; evening.minute = eveningMinute
        appState.morningNotifTime = morning
        appState.eveningNotifTime = evening
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

// MARK: - Reusable helpers
struct SettingsSectionHeader: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(color)
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .tracking(1)
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }
}

struct SettingsRow<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
