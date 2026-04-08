// AdhkarLibraryView.swift — Personal du'as library from Profile tab

import SwiftUI

struct AdhkarLibraryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                if appState.customAdhkar.isEmpty {
                    VStack(spacing: 20) {
                        EmptyLibraryView()
                        
                        Button {
                            showAddSheet = true
                        } label: {
                            Text("Add Your First Du'a")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.primaryGreen)
                                .cornerRadius(AppRadius.md)
                                .padding(.horizontal, 40)
                                .cardShadow()
                        }
                    }
                    .padding(.top, 60)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(appState.customAdhkar) { dhikr in
                                CustomDhikrCard(dhikr: dhikr) {
                                    appState.deleteCustomAdhkar(id: dhikr.id)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Adhkar Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.primaryGreen)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.primaryGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddDhikrEditor()
        }
    }
}

// MARK: - Components

struct EmptyLibraryView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.primaryGreen.opacity(0.1))
                    .frame(width: 120, height: 120)
                Text("📚")
                    .font(.system(size: 60))
            }
            
            VStack(spacing: 8) {
                Text("Your Adhkar Library is Empty")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text("Save personal du'as, verses, or custom dhikr to practice them anytime.")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
            }
        }
    }
}

struct CustomDhikrCard: View {
    let dhikr: Dhikr
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(dhikr.repetitions)×")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.primaryGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.primaryGreen.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(.red.opacity(0.7))
                }
            }
            
            Text(dhikr.arabic)
                .font(.system(size: AppFont.arabicMedium, weight: .regular))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.leading) // .leading in RTL = Right Alignment
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineSpacing(8)
                .environment(\.layoutDirection, .rightToLeft)

            if !dhikr.translation.isEmpty {
                Text(dhikr.translation)
                    .font(.system(size: 15))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(AppRadius.md)
        .cardShadow()
    }
}

// MARK: - Add Adhkar Editor (Premium Redesign)
struct AddDhikrEditor: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var arabic = ""
    @State private var translation = ""
    @State private var repetitions = 1
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case arabic, translation
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Page Header
                        VStack(spacing: 8) {
                            Text("Add Custom Adhkar")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("Save your personal du'as and dhikr")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 8)

                        // Form Card
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Arabic Text")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $arabic)
                                    .focused($focusedField, equals: .arabic)
                                    .frame(minHeight: 120)
                                    .padding(12)
                                    .background(Color.appBackground.opacity(0.5))
                                    .cornerRadius(AppRadius.sm)
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.sm)
                                            .stroke(focusedField == .arabic ? Color.primaryGreen : Color.clear, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Translation (Optional)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $translation)
                                    .focused($focusedField, equals: .translation)
                                    .frame(minHeight: 80)
                                    .padding(12)
                                    .background(Color.appBackground.opacity(0.5))
                                    .cornerRadius(AppRadius.sm)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.sm)
                                            .stroke(focusedField == .translation ? Color.primaryGreen : Color.clear, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Repetitions")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Text("\(repetitions)×")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                        .foregroundColor(.primaryGreen)
                                }
                                
                                Stepper("", value: $repetitions, in: 1...1000)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .padding(20)
                        .background(Color.cardBackground)
                        .cornerRadius(AppRadius.lg)
                        .cardShadow()
                        .padding(.horizontal, 16)
                        
                        // Save Button
                        Button {
                            save()
                        } label: {
                            Text("Save to Library")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(arabic.isEmpty ? Color.gray.opacity(0.3) : Color.primaryGreen)
                                .cornerRadius(AppRadius.md)
                        }
                        .disabled(arabic.isEmpty)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.textSecondary)
                }
            }
            .onAppear {
                focusedField = .arabic
            }
        }
    }
    
    private func save() {
        guard !arabic.isEmpty else { return }
        appState.addCustomAdhkar(arabic: arabic, translation: translation, repetitions: repetitions)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss()
    }
}

#Preview {
    AdhkarLibraryView()
        .environmentObject(AppState())
}
