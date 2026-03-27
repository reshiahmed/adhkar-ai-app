// DhikrCardView.swift — Individual adhkar card matching the PWA design

import SwiftUI

struct DhikrCardView: View {
    let dhikr: Dhikr
    let isEditMode: Bool
    let onIncrement: () -> Void
    let onToggleVisibility: () -> Void

    @State private var isExpanded: Bool = true
    @State private var showCompletionBurst = false

    private var counterLabel: String {
        "\(dhikr.currentCount)/\(dhikr.repetitions)x"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Arabic text + counter button
            HStack(alignment: .top, spacing: 12) {

                // Counter badge top-right in PWA is floating — here we do right side
                VStack {
                    // Counter indicator label
                    Text(counterLabel)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(dhikr.isCompleted ? .white : .primaryGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(dhikr.isCompleted ? Color.primaryGreen : Color.lightGreen)
                        .cornerRadius(AppRadius.full)
                }

                Spacer()

                // (+) circular counter button
                Button {
                    onIncrement()
                    if dhikr.currentCount + 1 >= dhikr.repetitions {
                        triggerCompletionBurst()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(dhikr.isCompleted ? Color.primaryGreen : Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.primaryGreen, lineWidth: 2)
                            )

                        if dhikr.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primaryGreen)
                        }
                    }
                }
                .scaleEffect(showCompletionBurst ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: showCompletionBurst)
                .disabled(dhikr.isCompleted)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Arabic text (RTL)
            if !isEditMode {
                Text(dhikr.arabic)
                    .font(.system(size: AppFont.arabicLarge))
                    .multilineTextAlignment(.trailing)
                    .environment(\.layoutDirection, .rightToLeft)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                // Transliteration
                if isExpanded {
                    Text(dhikr.transliteration)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .italic()
                        .foregroundColor(.secondaryGreen)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)

                    // Translation
                    Text(dhikr.translation)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .lineSpacing(3)
                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                }
            }

            // Source tag
            if let source = dhikr.source, !source.isEmpty {
                HStack {
                    Spacer()
                    Text(source)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.appBackground)
                        .cornerRadius(AppRadius.full)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            // Expand/collapse toggle
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }

            // Edit mode controls
            if isEditMode {
                Divider()
                    .padding(.horizontal, 16)

                HStack {
                    Label(
                        dhikr.isVisible ? "Visible" : "Hidden",
                        systemImage: dhikr.isVisible ? "eye" : "eye.slash"
                    )
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(dhikr.isVisible ? .primaryGreen : .textSecondary)

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: { dhikr.isVisible },
                        set: { _ in onToggleVisibility() }
                    ))
                    .tint(.primaryGreen)
                    .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
        .opacity(dhikr.isVisible ? 1.0 : 0.45)
    }

    private func triggerCompletionBurst() {
        showCompletionBurst = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            showCompletionBurst = false
        }
    }
}

#Preview {
    DhikrCardView(
        dhikr: AdhkarData.morning[0],
        isEditMode: false,
        onIncrement: {},
        onToggleVisibility: {}
    )
    .padding()
    .background(Color.appBackground)
}
