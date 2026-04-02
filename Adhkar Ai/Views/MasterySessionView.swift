// MasterySessionView.swift — Interactive SRS review session

import SwiftUI

struct MasterySessionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let items: [Dhikr]
    let mode: MasteryMode
    
    @State private var currentIndex: Int = 0
    @State private var revealCount: Int = 1
    @State private var showFeedback: Bool = false
    @State private var showTranslation: Bool = false
    
    enum MasteryMode {
        case review
        case test
    }
    
    private var currentItem: Dhikr {
        items[currentIndex]
    }
    
    private var segments: [DhikrSegment] {
        appState.segmentArabicText(currentItem.arabic)
    }
    
    private var progress: Double {
        Double(currentIndex + 1) / Double(items.count)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.textSecondary)
                            .frame(width: 44, height: 44)
                    }
                    
                    VStack(spacing: 4) {
                        ProgressView(value: progress)
                            .tint(.primaryGreen)
                            .background(Color.divider)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        
                        Text("\(currentIndex + 1) of \(items.count)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Text(mode == .test ? "TEST" : "REVIEW")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.lightGreen)
                        .foregroundColor(.primaryGreen)
                        .cornerRadius(6)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                Spacer()
                
                // Card Area
                VStack(spacing: 24) {
                    // Item Card
                    VStack(spacing: 20) {
                        // Arabic Segments
                        FlowLayout(spacing: 8) {
                            ForEach(segments) { segment in
                                let index = segments.firstIndex(where: { $0.id == segment.id })!
                                let isRevealed = index < revealCount
                                
                                Text(segment.content)
                                    .font(.system(size: 28, weight: .medium, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textPrimary)
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .opacity(isRevealed ? 1.0 : (mode == .test ? 0.0 : 0.05))
                                    .blur(radius: isRevealed ? 0 : (mode == .test ? 0 : 8))
                                    .scaleEffect(isRevealed ? 1.0 : 0.98)
                                    .animation(.easeInOut(duration: 0.6), value: revealCount)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleTap()
                        }
                        
                        if showTranslation {
                            VStack(spacing: 12) {
                                Text(currentItem.transliteration)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .italic()
                                    .foregroundColor(.secondaryGreen)
                                    .multilineTextAlignment(.center)
                                
                                Text(currentItem.translation)
                                    .font(.system(size: 15))
                                    .foregroundColor(.textPrimary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                
                                if let benefit = currentItem.benefit, !benefit.isEmpty {
                                    Text(benefit)
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                        .padding(12)
                                        .background(Color.lightGreen.opacity(0.5))
                                        .cornerRadius(12)
                                        .padding(.top, 8)
                                }
                            }
                            .padding(.horizontal, 20)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        if !showFeedback && !showTranslation {
                            Text(revealCount < segments.count ? "Tap to reveal next segment" : "Tap for translation")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                                .opacity(0.6)
                        }
                    }
                    .padding(24)
                    .background(Color.cardBackground)
                    .cornerRadius(32)
                    .cardShadow()
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    if showFeedback {
                        VStack(spacing: 16) {
                            Text("Did you remember it?")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.textSecondary)
                            
                            HStack(spacing: 12) {
                                FeedbackButton(label: "No", sublabel: "Again", color: .errorRed) {
                                    submitFeedback(0)
                                }
                                FeedbackButton(label: "Almost", sublabel: "Soon", color: .textPrimary) {
                                    submitFeedback(1)
                                }
                                FeedbackButton(label: "Yes", sublabel: "Good", color: .primaryGreen) {
                                    submitFeedback(2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Spacer()
                
                // Footer Navigation
                HStack {
                    Button {
                        if currentIndex > 0 {
                            withAnimation {
                                currentIndex -= 1
                                resetState()
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(currentIndex > 0 ? .textPrimary : .divider)
                    }
                    .disabled(currentIndex == 0)
                    
                    Spacer()
                    
                    if revealCount < segments.count {
                        Button {
                            withAnimation {
                                revealCount = segments.count
                                showTranslation = true
                                showFeedback = true
                            }
                        } label: {
                            Text("Reveal All")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.divider.opacity(0.5))
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        if currentIndex < items.count - 1 {
                            withAnimation {
                                currentIndex += 1
                                resetState()
                            }
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: currentIndex < items.count - 1 ? "chevron.right" : "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleTap() {
        if revealCount < segments.count {
            withAnimation(.easeInOut(duration: 0.6)) {
                revealCount += 1
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else if !showTranslation {
            withAnimation {
                showTranslation = true
                showFeedback = true
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    private func resetState() {
        revealCount = mode == .review ? segments.count : 1
        showFeedback = mode == .review
        showTranslation = mode == .review
    }
    
    private func submitFeedback(_ score: Int) {
        appState.updateMasterySRS(id: currentItem.id, confidence: score)
        
        if currentIndex < items.count - 1 {
            withAnimation {
                currentIndex += 1
                resetState()
            }
        } else {
            dismiss()
        }
    }
}

// MARK: - Components

struct FeedbackButton: View {
    let label: String
    let sublabel: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 16, weight: .bold))
                Text(sublabel)
                    .font(.system(size: 11, weight: .regular))
                    .opacity(0.8)
            }
            .foregroundColor(color == .primaryGreen ? .white : color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color == .primaryGreen ? color : Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: color == .primaryGreen ? 0 : 1)
            )
        }
    }
}

// Simple FlowLayout for segments
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX + size.width > width {
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            maxRowHeight = max(maxRowHeight, size.height)
            currentX += size.width + spacing
        }
        height = currentY + maxRowHeight
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.maxX
        var currentY: CGFloat = bounds.minY
        var maxRowHeight: CGFloat = 0
        
        // RTL placement
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if currentX - size.width < bounds.minX {
                currentX = bounds.maxX
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            view.place(at: CGPoint(x: currentX - size.width, y: currentY), proposal: .unspecified)
            maxRowHeight = max(maxRowHeight, size.height)
            currentX -= (size.width + spacing)
        }
    }
}

#Preview {
    MasterySessionView(items: [AdhkarData.morning[0], AdhkarData.morning[1]], mode: .test)
        .environmentObject(AppState())
}
