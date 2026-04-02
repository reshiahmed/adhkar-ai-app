// OnboardingView.swift — Full 11-step registration/welcome flow

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0
    @State private var selectedChoices: [String: String] = [:]
    @State private var dhikrCounter = 0
    @State private var isCalibrating = false
    @State private var calibrationDone = false
    
    enum StepType {
        case welcome, benefit, choice, plan, dhikr, feedback, final
    }
    
    struct ChoiceOption: Identifiable {
        let id: String
        let label: String
        let sub: String
        let emoji: String
    }
    
    struct OnboardingStep: Identifiable {
        let id: String
        let type: StepType
        var title: String = ""
        var description: String = ""
        var systemImage: String = ""
        var color: Color = .primaryGreen
        var options: [ChoiceOption] = []
    }
    
    let steps: [OnboardingStep] = [
        OnboardingStep(id: "welcome", type: .welcome),
        OnboardingStep(
            id: "benefit",
            type: .benefit,
            title: "The Science of Mastery",
            description: "Memorize effortlessly. Our smart system shows you the right Adhkar at the perfect time so they stay in your heart forever.",
            systemImage: "brain.headset",
            color: .blue
        ),
        OnboardingStep(
            id: "purpose",
            type: .choice,
            title: "Why are you here?",
            description: "Reflecting on your intention makes the practice more meaningful.",
            options: [
                ChoiceOption(id: "connection", label: "Be closer to Allah", sub: "Deepen your relationship", emoji: "🌿"),
                ChoiceOption(id: "consistency", label: "Build Consistency", sub: "Stop struggling with daily routine", emoji: "⏳"),
                ChoiceOption(id: "memorization", label: "Memorization", sub: "Learn and retain more Adhkar", emoji: "🎓")
            ]
        ),
        OnboardingStep(
            id: "practiceStyle",
            type: .choice,
            title: "How do you want to practice?",
            description: "Choose your preferred way to interact with the app.",
            options: [
                ChoiceOption(id: "guided", label: "Guided daily routine", sub: "Let the app direct you", emoji: "🧭"),
                ChoiceOption(id: "custom", label: "Build my own list", sub: "Complete control", emoji: "📝"),
                ChoiceOption(id: "mixed", label: "A mix of both", sub: "The best of both worlds", emoji: "✨")
            ]
        ),
        OnboardingStep(
            id: "timeCommitment",
            type: .choice,
            title: "Daily Commitment",
            description: "How much time can you realistically give each day?",
            options: [
                ChoiceOption(id: "3", label: "2–3 minutes", sub: "Quick & focused", emoji: "⏱️"),
                ChoiceOption(id: "7", label: "5–7 minutes", sub: "Moderate & meaningful", emoji: "⏳"),
                ChoiceOption(id: "15", label: "10+ minutes", sub: "Deep & intentional", emoji: "🏆")
            ]
        ),
        OnboardingStep(
            id: "experienceLevel",
            type: .choice,
            title: "Experience Level",
            description: "How familiar are you with these Adhkar?",
            options: [
                ChoiceOption(id: "beginner", label: "Beginner", sub: "New to most items", emoji: "🌱"),
                ChoiceOption(id: "intermediate", label: "Intermediate", sub: "Familiar with common ones", emoji: "🌿"),
                ChoiceOption(id: "advanced", label: "Advanced", sub: "Know many by heart", emoji: "🌳")
            ]
        ),
        OnboardingStep(
            id: "displaySettings",
            type: .choice,
            title: "Display Settings",
            description: "How would you like to see your Adhkar?",
            options: [
                ChoiceOption(id: "all", label: "Arabic + English", sub: "Arabic, transliteration, and meaning", emoji: "📖"),
                ChoiceOption(id: "arabic", label: "Arabic Only", sub: "Focus strictly on the Arabic script", emoji: "✍️")
            ]
        ),
        OnboardingStep(id: "plan", type: .plan),
        OnboardingStep(id: "first_dhikr", type: .dhikr),
        OnboardingStep(id: "feedback", type: .feedback),
        OnboardingStep(id: "final", type: .final)
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            // Logic for Calibration animation
            VStack(spacing: 0) {
                // Header (Skip / Back)
                HStack {
                    if currentStep > 0 {
                        Button {
                            withAnimation(.spring()) { currentStep -= 1 }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Step Dots
                HStack(spacing: 6) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentStep ? Color.primaryGreen : Color.divider)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.top, 16)
                
                // Content
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        StepContentView(
                            step: steps[i],
                            selectedChoiceId: selectedChoices[steps[i].id],
                            dhikrCounter: $dhikrCounter,
                            isCalibrating: $isCalibrating,
                            calibrationDone: $calibrationDone,
                            onChoice: { val in
                                withAnimation(.spring()) {
                                    selectedChoices[steps[i].id] = val
                                    applyChoice(stepId: steps[i].id, val: val)
                                    // Auto-advance for choice steps?
                                    // if steps[i].type == .choice { next() }
                                }
                            }
                        )
                        .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Footer
                VStack(spacing: 20) {
                    Button {
                        next()
                    } label: {
                        Text(currentStep == steps.count - 1 ? "Let's Get Started" : "Continue")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(canContinue ? Color.primaryGreen : Color.divider)
                            .cornerRadius(18)
                            .padding(.horizontal, 30)
                            .shadow(color: canContinue ? Color.primaryGreen.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                    }
                    .disabled(!canContinue)
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    private var canContinue: Bool {
        let step = steps[currentStep]
        if step.type == .choice {
            return selectedChoices[step.id] != nil
        }
        if step.type == .plan {
            return calibrationDone
        }
        if step.type == .dhikr {
            return dhikrCounter >= 3
        }
        return true
    }
    
    private func next() {
        if currentStep < steps.count - 1 {
            withAnimation(.spring()) {
                currentStep += 1
                if steps[currentStep].type == .plan {
                    startCalibration()
                }
            }
        } else {
            completeOnboarding()
        }
    }
    
    private func startCalibration() {
        isCalibrating = true
        calibrationDone = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                isCalibrating = false
                calibrationDone = true
            }
        }
    }
    
    private func applyChoice(stepId: String, val: String) {
        // Apply settings changes based on choices immediately or at the end
        if stepId == "displaySettings" {
            let isArabicOnly = val == "arabic"
            appState.showTranslation = !isArabicOnly
            appState.showTransliteration = !isArabicOnly
        }
        // More mapping can go here for daily goals, etc.
    }
    
    private func completeOnboarding() {
        withAnimation(.spring()) {
            appState.hasCompletedOnboarding = true
        }
    }
}

// MARK: - Step Content View
struct StepContentView: View {
    let step: OnboardingView.OnboardingStep
    let selectedChoiceId: String?
    @Binding var dhikrCounter: Int
    @Binding var isCalibrating: Bool
    @Binding var calibrationDone: Bool
    let onChoice: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            switch step.type {
            case .welcome:
                VStack(spacing: 32) {
                    Image("WelcomeLogo") // PNG Asset from PWA
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(24)
                        .shadow(radius: 20)
                    
                    Text("Adhkar AI")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("\"The most beloved deeds to Allah are those done consistently, even if small.\"")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(.textSecondary)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
            case .benefit:
                VStack(spacing: 24) {
                    Text(step.title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text(step.description)
                        .font(.system(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Simple illustration for SRS
                    HStack(spacing: 12) {
                        TourPill(label: "Morning")
                        TourPill(label: "Evening")
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primaryGreen.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(Text("🧠").font(.largeTitle))
                    }
                    .padding(.top, 20)
                }
                
            case .choice:
                VStack(spacing: 16) {
                    Text(step.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text(step.description)
                        .font(.system(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    
                    ForEach(step.options) { option in
                        Button {
                            onChoice(option.id)
                        } label: {
                            HStack(spacing: 16) {
                                Text(option.emoji)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(Color.appBackground)
                                    .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(option.label)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(option.sub)
                                        .font(.system(size: 12))
                                        .foregroundColor(.textSecondary)
                                }
                                Spacer()
                                if selectedChoiceId == option.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.primaryGreen)
                                }
                            }
                            .padding(16)
                            .background(Color.cardBackground)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selectedChoiceId == option.id ? Color.primaryGreen : Color.clear, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(selectedChoiceId == option.id ? 0.05 : 0.02), radius: 10)
                        }
                        .padding(.horizontal, 24)
                        .buttonStyle(PlainButtonStyle())
                        .id(option.id) // Ensure centered scroll if list is long
                    }
                }
                
            case .plan:
                VStack(spacing: 24) {
                    if isCalibrating {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.primaryGreen)
                        Text("Calibrating your experience...")
                            .font(.system(size: 22, weight: .bold))
                        Text("Our system is mapping your path to consistency based on your goals.")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                    } else {
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundColor(.primaryGreen)
                        Text("Perfectly tailored.")
                            .font(.system(size: 26, weight: .bold))
                        Text("Based on your goals, your personalized roadmap is ready. We've started you with the most essential Adhkar.")
                            .font(.system(size: 15))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                
            case .dhikr:
                VStack(spacing: 32) {
                    Text("First Dhikr")
                        .font(.system(size: 24, weight: .bold))
                    Text("Complete 3 counts of 'SubhanAllah' to activate your neural baseline.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    VStack(spacing: 20) {
                        Text("سُبْحَانَ اللَّهِ")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.primaryGreen)
                        
                        Button {
                            if dhikrCounter < 3 {
                                dhikrCounter += 1
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryGreen)
                                    .frame(width: 80, height: 80)
                                Text("\(3 - dhikrCounter)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(dhikrCounter >= 3)
                    }
                    .padding(32)
                    .background(Color.cardBackground)
                    .cornerRadius(24)
                    .shadow(radius: 10)
                }
                
            case .feedback:
                VStack(spacing: 24) {
                    Text("Streak Started")
                        .font(.headline)
                        .foregroundColor(.primaryGreen)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.lightGreen)
                        .cornerRadius(100)
                    
                    Text("1")
                        .font(.system(size: 80, weight: .black))
                        .foregroundColor(.primaryGreen)
                    
                    // Simple Calendar visualization
                    HStack(spacing: 8) {
                        ForEach(0..<7) { i in
                            Circle()
                                .fill(i == 3 ? Color.primaryGreen : Color.divider)
                                .frame(width: 30, height: 30)
                                .overlay(Text(i == 3 ? "✓" : "").font(.caption).bold().foregroundColor(.white))
                        }
                    }
                }
                
            case .final:
                VStack(spacing: 32) {
                    Image("NoBackgroundLogo") // Transparent PNG from PWA
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 180)
                    
                    Text("Welcome to Adhkar AI")
                        .font(.system(size: 28, weight: .black))
                    
                    Text("May Allah (SWT) reward you for your dedication and make this journey easy for you.")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct TourPill: View {
    let label: String
    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
