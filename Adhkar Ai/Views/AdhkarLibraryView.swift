// AdhkarLibraryView.swift — Personal du'as library (reads from AppState, persisted)

import SwiftUI

struct AdhkarLibraryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showAddSheet   = false
    @State private var newArabic      = ""
    @State private var newTranslation = ""
    @State private var newTranslit    = ""
    @State private var newRepetitions = 1

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                if appState.customDhikr.isEmpty {
                    VStack(spacing: 16) {
                        Text("📚")
                            .font(.system(size: 60))
                        Text("Your Adhkar Library")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Add personal du'as to practice and track")
                            .font(.system(size: 15))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        Button {
                            showAddSheet = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                Text("Add Du'a")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(Color.primaryGreen)
                            .cornerRadius(AppRadius.full)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(appState.customDhikr) { dhikr in
                            DhikrCardView(
                                dhikr: dhikr,
                                isEditMode: false,
                                onIncrement: {},
                                onToggleVisibility: {}
                            )
                            .listRowBackground(Color.appBackground)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .onDelete { appState.deleteCustomDhikr(at: $0) }
                    }
                    .listStyle(.plain)
                    .background(Color.appBackground)
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
                        Image(systemName: "plus")
                            .foregroundColor(.primaryGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddDhikrSheet(
                arabic: $newArabic,
                transliteration: $newTranslit,
                translation: $newTranslation,
                repetitions: $newRepetitions
            ) {
                guard !newArabic.isEmpty else { return }
                let dhikr = Dhikr(
                    arabic: newArabic,
                    transliteration: newTranslit,
                    translation: newTranslation,
                    repetitions: newRepetitions,
                    category: .custom
                )
                appState.addCustomDhikr(dhikr)
                newArabic = ""; newTranslit = ""; newTranslation = ""; newRepetitions = 1
            }
        }
    }
}

// MARK: - Add Sheet
struct AddDhikrSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var arabic: String
    @Binding var transliteration: String
    @Binding var translation: String
    @Binding var repetitions: Int
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Arabic Text *") {
                    TextField("Enter Arabic text...", text: $arabic, axis: .vertical)
                        .font(.system(size: AppFont.arabicMedium))
                        .environment(\.layoutDirection, .rightToLeft)
                        .lineLimit(3...8)
                }
                Section("Transliteration (Optional)") {
                    TextField("e.g. Bismillah...", text: $transliteration, axis: .vertical)
                        .lineLimit(2...4)
                }
                Section("Translation (Optional)") {
                    TextField("Enter translation or meaning...", text: $translation, axis: .vertical)
                        .lineLimit(2...5)
                }
                Section("Repetitions") {
                    Stepper("\(repetitions)×", value: $repetitions, in: 1...10000)
                }
            }
            .navigationTitle("Add Du'a")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.primaryGreen)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(arabic.isEmpty ? .gray : .primaryGreen)
                    .disabled(arabic.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AdhkarLibraryView()
        .environmentObject(AppState())
}
