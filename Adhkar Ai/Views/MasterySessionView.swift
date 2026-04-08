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
    @State private var dragOffset: CGFloat = 0
    @State private var cardOpacity: Double = 1.0
    @State private var sessionItems: [Dhikr] = []
    @State private var isAnimatingSwipe: Bool = false
    
    enum MasteryMode {
        case review
        case test
    }
    
    private var activeItems: [Dhikr] {
        sessionItems.isEmpty ? items : sessionItems
    }

    private var currentItem: Dhikr {
        let clamped = max(0, min(currentIndex, activeItems.count - 1))
        return activeItems[clamped]
    }
    
    private var segments: [DhikrSegment] {
        appState.segmentArabicText(currentItem.arabic)
    }
    
    private var revealStep: Int {
        segments.count > 10 ? 3 : 2
    }
    
    private var progress: Double {
        guard activeItems.count > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(activeItems.count)
    }
    
    // Subtle rotation during drag for natural feel (max ±6 degrees)
    private var dragRotation: Double {
        let maxDeg: Double = 6
        return max(-maxDeg, min(maxDeg, Double(dragOffset) / 40))
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: Header
                HStack {
                    Button { dismiss() } label: {
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
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
                        
                        Text("\(currentIndex + 1) of \(activeItems.count)")
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
                
                // MARK: Card + Feedback (move together during swipe)
                VStack(spacing: 24) {
                    // Card
                    VStack(spacing: 14) {
                        // Arabic Segments
                        FlowLayout(spacing: 8) {
                            ForEach(segments) { segment in
                                let index = segments.firstIndex(where: { $0.id == segment.id }) ?? 0
                                let isRevealed = index < revealCount
                                
                                Text(segment.content)
                                    .font(.system(size: 28, weight: .medium, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textPrimary)
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .opacity(isRevealed ? 1.0 : (mode == .test ? 0.0 : 0.05))
                                    .blur(radius: isRevealed ? 0 : (mode == .test ? 0 : 8))
                                    .scaleEffect(isRevealed ? 1.0 : 0.95)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                        .padding(.bottom, 8)
                        .contentShape(Rectangle())
                        .onTapGesture { handleTap() }
                        
                        // Translation
                        if showTranslation {
                            VStack(spacing: 12) {
                                if !currentItem.transliteration.isEmpty {
                                    Text(currentItem.transliteration)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .italic()
                                        .foregroundColor(.secondaryGreen)
                                        .multilineTextAlignment(.center)
                                }
                                
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
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                        
                        // Hint
                        if !showFeedback && !showTranslation {
                            Text(revealCount < segments.count ? "Tap to reveal next segment" : "Tap for translation")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                                .opacity(0.6)
                                .transition(.opacity)
                        }
                    }
                    .id(currentIndex)
                    .padding(24)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(.ultraThinMaterial)
                            
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.4), Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.8
                                )
                        }
                    }
                    .cardShadow()
                    .padding(.horizontal, 20)
                    .rotationEffect(.degrees(dragRotation), anchor: .bottom)
                    
                    // Feedback Buttons
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
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .offset(x: dragOffset)
                .opacity(cardOpacity)
                .gesture(
                    DragGesture(minimumDistance: 15)
                        .onChanged { value in
                            guard !isAnimatingSwipe else { return }
                            let translation = value.translation.width
                            // Rubber-band resistance at edges
                            if (translation > 0 && currentIndex == 0) ||
                               (translation < 0 && currentIndex >= activeItems.count - 1) {
                                dragOffset = translation * 0.3
                            } else {
                                dragOffset = translation
                            }
                        }
                        .onEnded { value in
                            guard !isAnimatingSwipe else { return }
                            let threshold: CGFloat = 60
                            let velocity = value.predictedEndTranslation.width - value.translation.width
                            let translation = value.translation.width
                            
                            // Swipe left -> next
                            if (translation < -threshold || velocity < -300) && currentIndex < activeItems.count - 1 {
                                performSwipe(toNext: true)
                            }
                            // Swipe right -> previous
                            else if (translation > threshold || velocity > 300) && currentIndex > 0 {
                                performSwipe(toNext: false)
                            }
                            // Swipe left on last card -> dismiss
                            else if (translation < -threshold || velocity < -300) && currentIndex >= activeItems.count - 1 {
                                dismissWithSwipe()
                            }
                            // Below threshold -> snap back
                            else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    dragOffset = 0
                                    cardOpacity = 1.0
                                }
                            }
                        }
                )
                
                Spacer()
                
                // MARK: Footer Navigation
                HStack {
                    Button {
                        guard !isAnimatingSwipe, currentIndex > 0 else { return }
                        performSwipe(toNext: false)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(currentIndex > 0 ? .textPrimary : .divider)
                    }
                    .disabled(currentIndex == 0 || isAnimatingSwipe)
                    
                    Spacer()
                    
                    if revealCount < segments.count {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                revealCount = segments.count
                                showTranslation = true
                                if mode == .test { showFeedback = true }
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
                        guard !isAnimatingSwipe else { return }
                        if currentIndex < activeItems.count - 1 {
                            performSwipe(toNext: true)
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: currentIndex < activeItems.count - 1 ? "chevron.right" : "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    .disabled(isAnimatingSwipe)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            sessionItems = mode == .review ? items.shuffled() : items
            currentIndex = 0
            resetState()
        }
    }
    
    // MARK: - Actions
    
    private func handleTap() {
        guard !isAnimatingSwipe else { return }
        
        if revealCount < segments.count {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                revealCount = min(revealCount + revealStep, segments.count)
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else if !showTranslation {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showTranslation = true
                if mode == .test { showFeedback = true }
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    private func resetState() {
        let newSegments = appState.segmentArabicText(currentItem.arabic)
        let step = newSegments.count > 10 ? 3 : 2
        revealCount = mode == .review ? newSegments.count : step
        showFeedback = false
        showTranslation = mode == .review
    }
    
    private func submitFeedback(_ score: Int) {
        appState.updateMasterySRS(id: currentItem.id, confidence: score)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if currentIndex < activeItems.count - 1 {
            performSwipe(toNext: true)
        } else {
            dismissWithSwipe()
        }
    }
    
    private func dismissWithSwipe() {
        let screenWidth = UIScreen.main.bounds.width
        isAnimatingSwipe = true
        withAnimation(.easeOut(duration: 0.15)) {
            dragOffset = -(screenWidth + 60)
            cardOpacity = 0.3
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dismiss()
        }
    }
    
    private func performSwipe(toNext: Bool) {
        guard !isAnimatingSwipe else { return }
        isAnimatingSwipe = true
        
        let screenWidth = UIScreen.main.bounds.width
        let direction: CGFloat = toNext ? -1 : 1
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Phase 1: Fast exit — card flies off and fades
        withAnimation(.easeOut(duration: 0.15)) {
            dragOffset = direction * (screenWidth + 60)
            cardOpacity = 0.4
        }
        
        // Phase 2: Instant swap, then glide new card in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            var t = Transaction(animation: nil)
            withTransaction(t) {
                currentIndex += toNext ? 1 : -1
                resetState()
                dragOffset = -direction * screenWidth * 0.25
                cardOpacity = 0
            }
            
            // Silky entrance — near-critically-damped spring + fade in
            withAnimation(.spring(response: 0.38, dampingFraction: 0.92)) {
                dragOffset = 0
                cardOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isAnimatingSwipe = false
            }
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
            .background {
                ZStack {
                    if color == .primaryGreen {
                        color
                    } else {
                        Color.clear
                            .background(.ultraThinMaterial)
                    }
                    
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                }
            }
            .cornerRadius(16)
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
