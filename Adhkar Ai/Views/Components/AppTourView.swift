// AppTourView.swift — Spotlight tour with preliminary prompt

import SwiftUI

struct AppTourView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: Int
    @State private var tourStep: Int = 0
    @State private var isPrompting: Bool = true // User feedback: Ask first
    
    struct StepInfo {
        let id: String
        let title: String
        let body: String
        let tabIndex: Int
        let emoji: String
    }
    
    let steps = [
        StepInfo(
            id: "morning",
            title: "Morning Adhkar",
            body: "Read each dhikr from the heart and press the counter to mark it as done. Work through the list every morning.",
            tabIndex: 0,
            emoji: "🌅"
        ),
        StepInfo(
            id: "evening",
            title: "Evening Adhkar",
            body: "Same structure as morning — best recited after Asr and just before sunset. A calm, consistent routine to keep your heart connected throughout the day.",
            tabIndex: 1,
            emoji: "🌙"
        ),
        StepInfo(
            id: "daily",
            title: "Daily Adhkar",
            body: "Fixed remembrances for everyday situations — eating, travelling, entering your home, and more. Great for staying connected throughout the day.",
            tabIndex: 2,
            emoji: "⏰"
        ),
        StepInfo(
            id: "knowledge",
            title: "Mastery",
            body: "Mastering Adhkar correctly is all about perfect timing. Our AI-powered Mastery system identifies the ideal moment for each review—making memorization simple and certain.",
            tabIndex: 3,
            emoji: "🎓"
        ),
        StepInfo(
            id: "progress",
            title: "Progress & Streaks",
            body: "See your daily completion, streak history, longest streak, and your overall growth over time.",
            tabIndex: 4,
            emoji: "📊"
        )
    ]
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .onTapGesture {
                    if !isPrompting { advanceTour() }
                }
            
            if isPrompting {
                TourPromptView(
                    onStart: { withAnimation { isPrompting = false } },
                    onSkip: { appState.hasCompletedTour = true }
                )
                .transition(.scale.combined(with: .opacity))
            } else {
                // Actual Tour Spotlight
                GeometryReader { geo in
                    let currentStep = steps[tourStep]
                    let totalTabs = 6
                    let tabWidth = geo.size.width / CGFloat(totalTabs)
                    let spotlightX = CGFloat(currentStep.tabIndex) * tabWidth + (tabWidth / 2)
                    let spotlightY = geo.size.height - 54
                    
                    VStack {
                        Spacer()
                        
                        // Tooltip Card (Optimized for Swift layout)
                        VStack(alignment: .leading, spacing: 16) {
                            // Step dots
                            HStack(spacing: 4) {
                                ForEach(0..<steps.count, id: \.self) { i in
                                    Capsule()
                                        .fill(i == tourStep ? Color.primaryGreen : (i < tourStep ? Color.primaryGreen.opacity(0.5) : Color.divider))
                                        .frame(width: i == tourStep ? 16 : 6, height: 6)
                                }
                            }
                            
                            HStack(spacing: 12) {
                                Text(currentStep.emoji)
                                    .font(.system(size: 30))
                                Text(currentStep.title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            Text(currentStep.body)
                                .font(.system(size: 15))
                                .foregroundColor(.textSecondary)
                                .lineSpacing(2)
                            
                            HStack {
                                Button("Skip Tour") {
                                    appState.hasCompletedTour = true
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                                
                                Spacer()
                                
                                if tourStep > 0 {
                                    Button("Back") {
                                        withAnimation { tourStep -= 1; selectedTab = steps[tourStep].tabIndex }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.secondary)
                                }
                                
                                Button(tourStep == steps.count - 1 ? "Finish ✓" : "Next →") {
                                    advanceTour()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.primaryGreen)
                            }
                            .padding(.top, 8)
                        }
                        .padding(24)
                        .background(Color.cardBackground)
                        .cornerRadius(24)
                        .shadow(radius: 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80) // Stay above the spotlight
                        
                        // Spotlight
                        Circle()
                            .stroke(Color.primaryGreen, lineWidth: 4)
                            .frame(width: 60, height: 60)
                            .position(x: spotlightX, y: spotlightY)
                            .shadow(color: Color.primaryGreen.opacity(0.5), radius: 10)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: tourStep)
                    }
                }
            }
        }
        .transition(.opacity)
        .onAppear {
            if !isPrompting { selectedTab = steps[tourStep].tabIndex }
        }
    }
    
    private func advanceTour() {
        withAnimation(.spring()) {
            if tourStep < steps.count - 1 {
                tourStep += 1
                selectedTab = steps[tourStep].tabIndex
                UISelectionFeedbackGenerator().selectionChanged()
            } else {
                appState.hasCompletedTour = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
    }
}

// MARK: - Tour Prompt View
struct TourPromptView: View {
    let onStart: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("✨")
                .font(.system(size: 50))
            
            Text("Would you like a tour?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Let us guide you through the key features to help you get the most out of Adhkar AI.")
                .font(.system(size: 15))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                Button {
                    onStart()
                } label: {
                    Text("Start Tour")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.primaryGreen)
                        .cornerRadius(15)
                }
                
                Button {
                    onSkip()
                } label: {
                    Text("Skip for Now")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(30)
        .background(Color.cardBackground)
        .cornerRadius(30)
        .shadow(radius: 30)
        .padding(.horizontal, 30)
    }
}

#Preview {
    AppTourView(selectedTab: .constant(0))
        .environmentObject(AppState())
}
