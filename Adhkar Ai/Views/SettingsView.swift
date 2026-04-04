// SettingsView.swift — Visual customizations and app preferences
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let arabicFonts = ["System", "Amiri", "Scheherazade", "Lateef"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // 1. Live Preview Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Live Preview")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 16)
                            
                            PreviewDhikrCard()
                                .padding(.horizontal, 16)
                        }
                        
                        // 2. Reading Experience Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Reading Experience")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                // Arabic Font Size
                                SettingsSliderRow(
                                    icon: "textformat.size",
                                    iconColor: .primaryGreen,
                                    label: "Arabic Font Size",
                                    value: $appState.arabicFontSize,
                                    range: 20...48
                                )
                                
                                Divider().padding(.leading, 56)
                                
                                // Arabic Line Spacing
                                SettingsSliderRow(
                                    icon: "line.horizontal.3",
                                    iconColor: .primaryGreen,
                                    label: "Line Spacing",
                                    value: $appState.arabicLineSpacing,
                                    range: 0...24
                                )
                                
                                SettingsSliderRow(
                                    icon: "textformat",
                                    iconColor: .primaryGreen,
                                    label: "English Font Size",
                                    value: $appState.englishFontSize,
                                    range: 12...24
                                )
                                
                                Divider().padding(.leading, 56)
                                
                                // Arabic Font Style
                                SettingsPickerRow(
                                    icon: "text.justify.right",
                                    iconColor: .primaryGreen,
                                    label: "Arabic Font",
                                    selection: $appState.arabicFontName,
                                    options: arabicFonts
                                )
                            }
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .cardShadow()
                            .padding(.horizontal, 16)
                        }
                        
                        // 3. Content Visibility Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Content Visibility")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                SettingsToggleRow(
                                    icon: "a.magnify",
                                    iconColor: Color(hex: "3B82F6"),
                                    label: "Show Transliteration",
                                    isOn: $appState.showTransliteration
                                )
                                
                                Divider().padding(.leading, 56)
                                
                                SettingsToggleRow(
                                    icon: "character.book.closed",
                                    iconColor: Color(hex: "8B5CF6"),
                                    label: "Show Translation",
                                    isOn: $appState.showTranslation
                                )
                                
                                Divider().padding(.leading, 56)
                                
                                SettingsToggleRow(
                                    icon: "magnifyingglass.circle",
                                    iconColor: Color(hex: "F59E0B"),
                                    label: "Show Search Bars",
                                    isOn: $appState.showSearchBars
                                )
                            }
                            .background(Color.cardBackground)
                            .cornerRadius(16)
                            .cardShadow()
                            .padding(.horizontal, 16)
                        }
                        
                        // 4. Appearance Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Appearance")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 16)
                            
                            ThemeSelectionGroup()
                                .padding(.horizontal, 16)
                        }
                        
                        // Spacer for bottom pill
                        Color.clear.frame(height: 100)
                    }
                }
            }
            .navigationTitle("Global Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryGreen)
                }
            }
        }
    }
}

// MARK: - Components

struct PreviewDhikrCard: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("سُبْحَانَ اللَّهِ وَبِحَمْدِهِ")
                .font(.custom(appState.arabicFontName == "System" ? "" : appState.arabicFontName, size: appState.arabicFontSize))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)
                .lineSpacing(10)
            
            if appState.showTransliteration {
                Text("SubhanAllahi wa bihamdihi")
                    .font(.system(size: appState.englishFontSize, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(.primaryGreen)
                    .multilineTextAlignment(.center)
            }
            
            if appState.showTranslation {
                Text("Glory is to Allah and praise is to Him.")
                    .font(.system(size: appState.englishFontSize))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(24)
        .background(Color.cardBackground)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.primaryGreen.opacity(0.1), lineWidth: 1)
        )
        .cardShadow()
    }
}

struct SettingsSliderRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(Int(value))pt")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(.textSecondary)
            }
            
            Slider(value: $value, in: range, step: 1)
                .tint(.primaryGreen)
        }
        .padding(16)
    }
}

struct SettingsPickerRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { opt in
                    Text(opt).tag(opt)
                }
            }
            .pickerStyle(.menu)
            .tint(.primaryGreen)
        }
        .padding(16)
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(.primaryGreen)
                .labelsHidden()
        }
        .padding(16)
    }
}

struct ThemeSelectionGroup: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ThemeMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.spring()) {
                        appState.themeMode = mode
                    }
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 20))
                        Text(mode.rawValue.capitalized)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(appState.themeMode == mode ? Color.primaryGreen : Color.cardBackground)
                    .foregroundColor(appState.themeMode == mode ? .white : .textPrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(appState.themeMode == mode ? Color.clear : Color.divider.opacity(0.5), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
