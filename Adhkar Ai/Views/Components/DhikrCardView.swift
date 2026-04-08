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
        VStack(alignment: .center, spacing: 0) {
            // 1. Arabic Text (Top)
            VStack(alignment: .center, spacing: 0) {
                let segmentation = ArabicTextProcessor.segment(text: dhikr.arabic)
                
                if let bismillah = segmentation.bismillah {
                    Text(bismillah)
                        .font(.system(size: appState.arabicFontSize * 0.9, weight: .medium, design: .serif))
                        .foregroundColor(.primaryGreen)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                        .padding(.bottom, 8)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundColor(.textSecondary.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 16)
                }

                // Main Arabic Content
                DhikrFlowLayout(direction: .rightToLeft, spacing: 5) {
                    ForEach(segmentation.ayahs) { ayah in
                        let words = ayah.content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
                        
                        ForEach(0..<words.count, id: \.self) { index in
                            Text(words[index])
                                .font(.system(size: appState.arabicFontSize, weight: .regular, design: .serif))
                                .foregroundColor(.textPrimary)
                        }
                        
                        if let number = ayah.number {
                            Text(number)
                                .font(.system(size: appState.arabicFontSize * 0.6, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryGreen)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(Color.primaryGreen.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.primaryGreen.opacity(0.3), lineWidth: 0.5)
                                        )
                                )
                                .shadow(color: Color.primaryGreen.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, segmentation.bismillah == nil ? 24 : 0)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)

            // 2. English Content (Center)
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    if appState.showTransliteration && !dhikr.transliteration.isEmpty {
                        Text(dhikr.transliteration)
                            .font(.system(size: appState.transliterationFontSize, weight: .regular, design: .rounded))
                            .italic()
                            .foregroundColor(.secondaryGreen)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if appState.showTranslation && !dhikr.translation.isEmpty {
                        Text(dhikr.translation)
                            .font(.system(size: appState.translationFontSize))
                            .foregroundColor(.textSecondary)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

            // 3. Interactive Bottom Row
            HStack(alignment: .center, spacing: 12) {
                // Source Tag (Now on the Left)
                if let source = dhikr.source, !source.isEmpty {
                    Text(source)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appBackground.opacity(0.6))
                        .cornerRadius(AppRadius.full)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // Counter Label (Now next to the button)
                if showCounter {
                    Text(counterLabel)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(dhikr.isCompleted ? .white : .primaryGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(dhikr.isCompleted ? Color.primaryGreen : Color.lightGreen)
                        .cornerRadius(12)
                }

                // Action Button (Increment or Visibility Toggle)
                if isEditMode || showCounter {
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

// MARK: - Supporting Views

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct DhikrFlowLayout: Layout {
    var direction: LayoutDirection = .rightToLeft
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? UIScreen.main.bounds.width - 32
        let result = layout(maxWidth: width, subviews: subviews)
        return result.size
    }

    func placeSubviews(in rect: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(maxWidth: rect.width, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            var point = result.points[index]
            
            // Mirror X if RTL
            if direction == .rightToLeft {
                let size = subview.sizeThatFits(.unspecified)
                point.x = rect.width - point.x - size.width
            }
            
            subview.place(at: CGPoint(x: rect.minX + point.x, y: rect.minY + point.y), proposal: .unspecified)
        }
    }

    private func layout(maxWidth: CGFloat, subviews: Subviews) -> (size: CGSize, points: [CGPoint]) {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        var points: [CGPoint] = Array(repeating: .zero, count: subviews.count)
        
        for index in 0..<subviews.count {
            let size = subviews[index].sizeThatFits(.unspecified)
            
            // Logically calculate LTR flow first
            if currentX + size.width > maxWidth && index > 0 {
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            
            points[index] = CGPoint(x: currentX, y: currentY)
            
            currentX += (size.width + spacing)
            maxRowHeight = max(maxRowHeight, size.height)
        }
        
        return (CGSize(width: maxWidth, height: currentY + maxRowHeight), points)
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
