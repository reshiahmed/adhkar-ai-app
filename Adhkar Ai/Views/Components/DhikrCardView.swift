// DhikrCardView.swift — Individual adhkar card matching the PWA design

import SwiftUI

struct DhikrCardView: View {
    @EnvironmentObject var appState: AppState
    let dhikr: Dhikr
    let isEditMode: Bool
    let showCounter: Bool
    let onIncrement: () -> Void
    let onToggleVisibility: () -> Void
    let onReset: () -> Void
    
    @State private var isExpanded: Bool = true
    @State private var showCompletionBurst = false

    init(dhikr: Dhikr, isEditMode: Bool, showCounter: Bool = true, onIncrement: @escaping () -> Void, onToggleVisibility: @escaping () -> Void, onReset: @escaping () -> Void) {
        self.dhikr = dhikr
        self.isEditMode = isEditMode
        self.showCounter = showCounter
        self.onIncrement = onIncrement
        self.onToggleVisibility = onToggleVisibility
        self.onReset = onReset
    }

    private var counterLabel: String {
        "\(dhikr.currentCount)/\(dhikr.repetitions)x"
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            // 1. Arabic Text (Top)
            Text(dhikr.arabic)
                .font(.custom(appState.arabicFontName == "System" ? "" : appState.arabicFontName, size: appState.arabicFontSize))
                .lineSpacing(appState.arabicLineSpacing)
                .multilineTextAlignment(.trailing)
                .environment(\.layoutDirection, .rightToLeft)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true) // Fix truncation
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 12)

            // 2. English Content (Center)
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    if appState.showTransliteration && !dhikr.transliteration.isEmpty {
                        Text(dhikr.transliteration)
                            .font(.system(size: appState.englishFontSize, weight: .regular, design: .rounded))
                            .italic()
                            .foregroundColor(.secondaryGreen)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if appState.showTranslation && !dhikr.translation.isEmpty {
                        Text(dhikr.translation)
                            .font(.system(size: appState.englishFontSize))
                            .foregroundColor(.textSecondary)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

            // 3. Interactive Bottom Row
            HStack(alignment: .center, spacing: 12) {
                // Counter Label (e.g. 1/3x)
                if showCounter {
                    Text(counterLabel)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(dhikr.isCompleted ? .white : .primaryGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(dhikr.isCompleted ? Color.primaryGreen : Color.lightGreen)
                        .cornerRadius(10)
                }

                Spacer()

                // Source Tag
                if let source = dhikr.source, !source.isEmpty {
                    Text(source)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.appBackground.opacity(0.5))
                        .cornerRadius(AppRadius.full)
                }

                // Action Button (Increment or Visibility Toggle)
                Button {
                    if isEditMode {
                        onToggleVisibility()
                    } else {
                        onIncrement()
                        if dhikr.currentCount + 1 >= dhikr.repetitions {
                            triggerCompletionBurst()
                        }
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(actionButtonColor)
                            .frame(width: 44, height: 44)
                            .cardShadow()

                        Image(systemName: actionButtonIcon)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(actionButtonContentColor)
                    }
                }
                .scaleEffect(showCompletionBurst ? 1.15 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: showCompletionBurst)
                .disabled(!isEditMode && dhikr.isCompleted)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            // Manual Expand Indicator (Subtle)
            if !isEditMode && (appState.showTransliteration || appState.showTranslation) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.textSecondary.opacity(0.5))
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(24)
        .cardShadow()
        .opacity(dhikr.isVisible ? 1.0 : 0.5)
        .onTapGesture {
            if showCounter && !dhikr.isCompleted && !isEditMode {
                onIncrement()
            }
        }
        .onLongPressGesture(minimumDuration: 0.6) {
            if showCounter && !isEditMode {
                onReset()
            }
        }
    }

    // MARK: - Helpers
    
    private var actionButtonIcon: String {
        if isEditMode {
            return dhikr.isVisible ? "eye.fill" : "eye.slash.fill"
        } else if dhikr.isCompleted {
            return "checkmark"
        } else {
            return "plus"
        }
    }

    private var actionButtonColor: Color {
        if isEditMode {
            return dhikr.isVisible ? .primaryGreen : Color.textSecondary.opacity(0.15)
        } else {
            return dhikr.isCompleted ? .primaryGreen : .lightGreen
        }
    }

    private var actionButtonContentColor: Color {
        if isEditMode {
            return .white
        } else {
            return dhikr.isCompleted ? .white : .primaryGreen
        }
    }

    private func triggerCompletionBurst() {
        showCompletionBurst = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showCompletionBurst = false
        }
    }
}

#Preview {
    DhikrCardView(
        dhikr: AdhkarData.morning[0],
        isEditMode: false,
        onIncrement: {},
        onToggleVisibility: {},
        onReset: {}
    )
    .padding()
    .background(Color.appBackground)
}
