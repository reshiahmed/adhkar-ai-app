// AppState.swift — Central state management (ObservableObject)

import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    private enum StorageKey {
        static let morningAdhkar = "adhkar.morning"
        static let eveningAdhkar = "adhkar.evening"
        static let progressHistory = "adhkar.progressHistory"
        static let themeMode = "adhkar.themeMode"
        static let masteryMetadata = "adhkar.masteryMetadata"
        static let dailyCategories = "adhkar.dailyCategories"
        static let dailyAdhkarStore = "adhkar.dailyStore"
        static let customAdhkar = "adhkar.custom"
        static let arabicFontSize = "adhkar.arabicFontSize"
        static let arabicFontName = "adhkar.arabicFontName"
        static let showTransliteration = "adhkar.showTransliteration"
        static let showTranslation = "adhkar.showTranslation"
        static let transliterationFontSize = "adhkar.transliterationFontSize"
        static let translationFontSize = "adhkar.translationFontSize"
        static let showSearchBars = "adhkar.showSearchBars"
        static let hasCompletedOnboarding = "adhkar.hasCompletedOnboarding"
        static let hasCompletedTour = "adhkar.hasCompletedTour"
        static let lastProgressReset = "adhkar.lastProgressReset"
    }

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Auth & Sync
    @Published var isLoggedIn: Bool = false
    @Published var isOfflineMode: Bool = false
    @Published var isSyncing: Bool = false
    @Published var syncStatus: String = "Saved"
    @Published var currentUser: User?
    @Published var selectedTab: Int = 0

    // MARK: - Onboarding & Tour
    @Published var hasCompletedOnboarding: Bool = false {
        didSet {
            defaults.set(hasCompletedOnboarding, forKey: StorageKey.hasCompletedOnboarding)
        }
    }
    @Published var hasCompletedTour: Bool = false {
        didSet {
            defaults.set(hasCompletedTour, forKey: StorageKey.hasCompletedTour)
        }
    }
    @Published var lastProgressReset: Date? {
        didSet {
            if let date = lastProgressReset {
                defaults.set(date, forKey: StorageKey.lastProgressReset)
            }
        }
    }

    // MARK: - Theme & Visuals
    @Published var themeMode: ThemeMode = .auto {
        didSet {
            defaults.set(themeMode.rawValue, forKey: StorageKey.themeMode)
            objectWillChange.send()
        }
    }

    @Published var arabicFontSize: Double = 26 {
        didSet {
            defaults.set(arabicFontSize, forKey: StorageKey.arabicFontSize)
            objectWillChange.send()
        }
    }
    
    @Published var transliterationFontSize: Double = 14 {
        didSet {
            defaults.set(transliterationFontSize, forKey: StorageKey.transliterationFontSize)
            objectWillChange.send()
        }
    }
    
    @Published var translationFontSize: Double = 14 {
        didSet {
            defaults.set(translationFontSize, forKey: StorageKey.translationFontSize)
            objectWillChange.send()
        }
    }
    
    @Published var showSearchBars: Bool = true {
        didSet {
            defaults.set(showSearchBars, forKey: StorageKey.showSearchBars)
            objectWillChange.send()
        }
    }
    
    @Published var arabicFontName: String = "System" {
        didSet {
            defaults.set(arabicFontName, forKey: StorageKey.arabicFontName)
            objectWillChange.send()
        }
    }
    
    @Published var showTransliteration: Bool = true {
        didSet {
            defaults.set(showTransliteration, forKey: StorageKey.showTransliteration)
            objectWillChange.send()
        }
    }
    
    @Published var showTranslation: Bool = true {
        didSet {
            defaults.set(showTranslation, forKey: StorageKey.showTranslation)
            objectWillChange.send()
        }
    }

    var colorScheme: ColorScheme? {
        switch themeMode {
        case .light: return .light
        case .dark:  return .dark
        case .auto:  return nil
        }
    }

    // MARK: - Adhkar Data
    @Published var morningAdhkar: [Dhikr] = AdhkarData.morning
    @Published var eveningAdhkar: [Dhikr] = AdhkarData.evening
    @Published var dailyCategories: [DailyCategory] = []
    @Published var dailyAdhkarStore: [String: [Dhikr]] = [:]
    
    @Published var customAdhkar: [Dhikr] = [] {
        didSet {
            if let index = dailyCategories.firstIndex(where: { $0.category == .custom }) {
                dailyCategories[index].adhkar = customAdhkar
            }
        }
    }

    private func setupCategories() {
        var baseCategories = AdhkarData.dailyCategories
        if !baseCategories.contains(.custom) { baseCategories.append(.custom) }
        
        self.dailyCategories = baseCategories.map { cat in
            if cat == .custom {
                return DailyCategory(category: .custom, adhkar: customAdhkar)
            } else {
                let adhkar = dailyAdhkarStore[cat.rawValue] ?? AdhkarData.adhkar(for: cat)
                return DailyCategory(category: cat, adhkar: adhkar)
            }
        }
    }

    @Published var isDailyEditMode: Bool = false
    @Published var isDailyGridEditMode: Bool = false
    @Published var isMorningEditMode: Bool = false
    @Published var isEveningEditMode: Bool = false

    @Published var progressHistory: [DailyProgressEntry] = []
    @Published var masteryMetadata: [String: MasteryMetadata] = [:]

    // MARK: - Logic & Helpers
    var morningCompleted: Int { morningAdhkar.filter { $0.isVisible && $0.isCompleted }.count }
    var morningTotal: Int { morningAdhkar.filter(\.isVisible).count }
    var morningAllDone: Bool { morningCompleted >= morningTotal && morningTotal > 0 }

    var eveningCompleted: Int { eveningAdhkar.filter { $0.isVisible && $0.isCompleted }.count }
    var eveningTotal: Int { eveningAdhkar.filter(\.isVisible).count }
    var eveningAllDone: Bool { eveningCompleted >= eveningTotal && eveningTotal > 0 }

    var totalDailyCount: Int { morningCompleted + eveningCompleted }

    // MARK: - Custom Adhkar Management
    func addCustomAdhkar(arabic: String, translation: String, repetitions: Int, benefit: String? = nil, pinTo: String? = nil) {
        let newDhikr = Dhikr(
            id: UUID().uuidString,
            arabic: arabic,
            transliteration: "",
            translation: translation,
            repetitions: repetitions,
            category: .custom,
            benefit: benefit,
            pinTo: pinTo
        )
        withAnimation(.spring()) {
            customAdhkar.insert(newDhikr, at: 0)
            persistState()
        }
    }

    func deleteCustomAdhkar(id: String) {
        withAnimation(.spring()) {
            customAdhkar.removeAll { $0.id == id }
            persistState()
        }
    }

    // MARK: - Persistence & Sync
    func persistState() {
        store(morningAdhkar, key: StorageKey.morningAdhkar)
        store(eveningAdhkar, key: StorageKey.eveningAdhkar)
        store(dailyCategories, key: StorageKey.dailyCategories)
        store(dailyAdhkarStore, key: StorageKey.dailyAdhkarStore)
        store(customAdhkar, key: StorageKey.customAdhkar)
        store(masteryMetadata, key: StorageKey.masteryMetadata)
        upsertTodayProgress()
        trimProgressHistory(maxEntries: 180)
        store(progressHistory, key: StorageKey.progressHistory)
        
        Task {
            await syncToCloud()
        }
    }

    func loadPersistedState() {
        if let storedMorning: [Dhikr] = load(forKey: StorageKey.morningAdhkar) {
            morningAdhkar = storedMorning
        }
        if let storedEvening: [Dhikr] = load(forKey: StorageKey.eveningAdhkar) {
            eveningAdhkar = storedEvening
        }
        if let storedDaily: [DailyCategory] = load(forKey: StorageKey.dailyCategories) {
            dailyCategories = storedDaily
        }
        if let storedDailyStore: [String: [Dhikr]] = load(forKey: StorageKey.dailyAdhkarStore) {
            dailyAdhkarStore = storedDailyStore
        }
        if let storedCustom: [Dhikr] = load(forKey: StorageKey.customAdhkar) {
            customAdhkar = storedCustom
        }
        if let storedProgress: [DailyProgressEntry] = load(forKey: StorageKey.progressHistory) {
            progressHistory = storedProgress
        }
        if let storedMastery: [String: MasteryMetadata] = load(forKey: StorageKey.masteryMetadata) {
            masteryMetadata = storedMastery
        }
        if let savedTheme = defaults.string(forKey: StorageKey.themeMode),
           let parsedTheme = ThemeMode(rawValue: savedTheme) {
            themeMode = parsedTheme
        }
        
        let savedSize = defaults.double(forKey: StorageKey.arabicFontSize)
        if savedSize > 0 { arabicFontSize = savedSize }
        
        if let savedFont = defaults.string(forKey: StorageKey.arabicFontName) {
            arabicFontName = savedFont
        }
        
        if defaults.object(forKey: StorageKey.showTransliteration) != nil {
            showTransliteration = defaults.bool(forKey: StorageKey.showTransliteration)
        }
        
        if defaults.object(forKey: StorageKey.showTranslation) != nil {
            showTranslation = defaults.bool(forKey: StorageKey.showTranslation)
        }
        
        if let savedTransliterationSize = defaults.object(forKey: StorageKey.transliterationFontSize) as? Double {
            transliterationFontSize = savedTransliterationSize
        }
        
        if let savedTranslationSize = defaults.object(forKey: StorageKey.translationFontSize) as? Double {
            translationFontSize = savedTranslationSize
        }
        
        if defaults.object(forKey: StorageKey.showSearchBars) != nil {
            showSearchBars = defaults.bool(forKey: StorageKey.showSearchBars)
        }
        
        hasCompletedOnboarding = defaults.bool(forKey: StorageKey.hasCompletedOnboarding)
        hasCompletedTour = defaults.bool(forKey: StorageKey.hasCompletedTour)
        lastProgressReset = defaults.object(forKey: StorageKey.lastProgressReset) as? Date
        
        setupCategories()
        checkDailyReset()
        setupNotificationObservers()
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.checkDailyReset()
            }
            .store(in: &cancellables)
    }

    func checkDailyReset() {
        let calendar = Calendar.current
        let now = Date()
        
        guard let lastReset = lastProgressReset else {
            // First run on this device. 
            // If we have no progress history locally, we can safely set now.
            // If we DO have history but no lastReset (legacy upgrade), we should reset once.
            if progressHistory.isEmpty && (morningAdhkar.allSatisfy { $0.currentCount == 0 }) {
                lastProgressReset = now
            } else {
                resetAllDailyProgress()
                lastProgressReset = now
            }
            return
        }
        
        // Only reset if today is officially a DIFFERENT day than last reset.
        if !calendar.isDate(lastReset, inSameDayAs: now) {
            // Logically, any progress still in the arrays belongs to 'lastReset' day.
            // But upsertTodayProgress always uses Date(). 
            // To ensure the previous day's final progress is recorded correctly, 
            // we'd need to know what day it was.
            
            resetAllDailyProgress()
            lastProgressReset = now
        }
    }

    private func resetAllDailyProgress() {
        withAnimation(.spring()) {
            for i in 0..<morningAdhkar.count { morningAdhkar[i].reset() }
            for i in 0..<eveningAdhkar.count { eveningAdhkar[i].reset() }
            
            for i in 0..<dailyCategories.count {
                for j in 0..<dailyCategories[i].adhkar.count {
                    dailyCategories[i].adhkar[j].reset()
                }
            }
            
            // Sync current dailyCategories state back to dailyAdhkarStore
            for cat in dailyCategories {
                dailyAdhkarStore[cat.category.rawValue] = cat.adhkar
            }
            
            persistState()
        }
    }

    // MARK: - Progress Helpers
    var totalDaysActive: Int {
        progressHistory.filter { $0.completionRatio > 0 }.count
    }
    
    var longestStreak: Int {
        streakDays 
    }

    var morningProgressPct: Int {
        let visible = morningAdhkar.filter(\.isVisible)
        guard !visible.isEmpty else { return 0 }
        let completed = visible.filter(\.isCompleted).count
        return Int(Double(completed) / Double(visible.count) * 100)
    }
    
    var eveningProgressPct: Int {
        let visible = eveningAdhkar.filter(\.isVisible)
        guard !visible.isEmpty else { return 0 }
        let completed = visible.filter(\.isCompleted).count
        return Int(Double(completed) / Double(visible.count) * 100)
    }
    
    var dailyProgressPct: Int {
        let visible = dailyCategories.flatMap { $0.adhkar }.filter(\.isVisible)
        guard !visible.isEmpty else { return 0 }
        let completed = visible.filter(\.isCompleted).count
        return Int(Double(completed) / Double(visible.count) * 100)
    }

    var overallMasteryPct: Int {
        let visibleCount = (morningAdhkar + eveningAdhkar).filter(\.isVisible).count + 
                          dailyCategories.flatMap { $0.adhkar }.filter(\.isVisible).count
        guard visibleCount > 0 else { return 0 }
        return Int(Double(memorizedCount) / Double(visibleCount) * 100)
    }

    var itemsDueToday: [Dhikr] {
        let all = (morningAdhkar + eveningAdhkar).filter { $0.isVisible }
        let today = Calendar.current.startOfDay(for: Date())
        return all.filter { dhikr in
            guard let meta = masteryMetadata[dhikr.id] else { return true } 
            return meta.nextReview <= today
        }
    }

    var memorizedCount: Int {
        masteryMetadata.values.filter { $0.status == .memorized }.count
    }

    var learningCount: Int {
        masteryMetadata.values.filter { $0.status == .learning }.count
    }

    func dueItems(for category: AdhkarCategory) -> [Dhikr] {
        let items = (category == .morning ? morningAdhkar : eveningAdhkar).filter { $0.isVisible }
        let today = Calendar.current.startOfDay(for: Date())
        return items.filter { dhikr in
            guard let meta = masteryMetadata[dhikr.id] else { return true }
            return meta.nextReview <= today
        }
    }
    
    var dailyCompletionRatio: Double {
        let morningRatio = morningTotal > 0 ? Double(morningCompleted) / Double(morningTotal) : 0
        let eveningRatio = eveningTotal > 0 ? Double(eveningCompleted) / Double(eveningTotal) : 0
        return (morningRatio + eveningRatio) / 2
    }

    var recentProgress14Days: [DailyProgressEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var points: [DailyProgressEntry] = []

        for offset in stride(from: 13, through: 0, by: -1) {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }

            if let existing = progressHistory.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                points.append(existing)
            } else {
                points.append(
                    DailyProgressEntry(
                        date: date,
                        morningCompleted: false,
                        eveningCompleted: false,
                        completionRatio: 0
                    )
                )
            }
        }
        return points
    }

    var completedDaysTotal: Int {
        progressHistory.filter { $0.completionRatio > 0 }.count
    }

    var streakDays: Int {
        let calendar = Calendar.current
        let sorted = progressHistory.sorted { $0.date > $1.date }
        var streak = 0
        var dayCursor = calendar.startOfDay(for: Date())

        for entry in sorted {
            let entryDate = calendar.startOfDay(for: entry.date)
            if !calendar.isDate(entryDate, inSameDayAs: dayCursor) {
                let nextExpected = calendar.date(byAdding: .day, value: -1, to: dayCursor) ?? dayCursor
                if !calendar.isDate(entryDate, inSameDayAs: nextExpected) {
                    break
                }
                dayCursor = nextExpected
            }

            if entry.morningCompleted && entry.eveningCompleted {
                streak += 1
                dayCursor = calendar.date(byAdding: .day, value: -1, to: dayCursor) ?? dayCursor
            } else if calendar.isDateInToday(entryDate) {
                continue
            } else {
                break
            }
        }
        return streak
    }
    
    func activityForDay(date: Date) -> (morning: Bool, evening: Bool, ratio: Double) {
        let calendar = Calendar.current
        if let entry = progressHistory.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return (entry.morningCompleted, entry.eveningCompleted, entry.completionRatio)
        }
        return (false, false, 0)
    }

    init() {
        loadPersistedState()
    }

    // MARK: - Adhkar Actions
    func resetMorning() {
        for i in morningAdhkar.indices { morningAdhkar[i].reset() }
        persistState()
    }

    func resetEvening() {
        for i in eveningAdhkar.indices { eveningAdhkar[i].reset() }
        persistState()
    }

    func incrementMorning(id: String) {
        if let i = morningAdhkar.firstIndex(where: { $0.id == id }) {
            morningAdhkar[i].increment()
            checkHaptic(completed: morningAdhkar[i].isCompleted)
            persistState()
        }
    }

    func resetIndividualMorning(id: String) {
        if let i = morningAdhkar.firstIndex(where: { $0.id == id }) {
            morningAdhkar[i].reset()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            persistState()
        }
    }

    func incrementEvening(id: String) {
        if let i = eveningAdhkar.firstIndex(where: { $0.id == id }) {
            eveningAdhkar[i].increment()
            checkHaptic(completed: eveningAdhkar[i].isCompleted)
            persistState()
        }
    }

    func resetIndividualEvening(id: String) {
        if let i = eveningAdhkar.firstIndex(where: { $0.id == id }) {
            eveningAdhkar[i].reset()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            persistState()
        }
    }

    func toggleMorningVisibility(id: String) {
        if let i = morningAdhkar.firstIndex(where: { $0.id == id }) {
            morningAdhkar[i].isVisible.toggle()
            persistState()
        }
    }

    func toggleEveningVisibility(id: String) {
        if let i = eveningAdhkar.firstIndex(where: { $0.id == id }) {
            eveningAdhkar[i].isVisible.toggle()
            persistState()
        }
    }

    func moveDailyCategory(from: IndexSet, to: Int) {
        withAnimation(.spring()) {
            dailyCategories.move(fromOffsets: from, toOffset: to)
            persistState()
        }
    }

    func toggleDailyVisibility(category: AdhkarCategory, id: String) {
        if let catIndex = dailyCategories.firstIndex(where: { $0.category == category }),
           let itemIndex = dailyCategories[catIndex].adhkar.firstIndex(where: { $0.id == id }) {
            withAnimation(.spring()) {
                dailyCategories[catIndex].adhkar[itemIndex].isVisible.toggle()
                persistState()
            }
        }
    }

    func moveDailyAdhkar(category: AdhkarCategory, from: IndexSet, to: Int) {
        if let catIndex = dailyCategories.firstIndex(where: { $0.category == category }) {
            withAnimation(.spring()) {
                dailyCategories[catIndex].adhkar.move(fromOffsets: from, toOffset: to)
                persistState()
            }
        }
    }

    // MARK: - Mastery SRS Logic
    func updateMasterySRS(id: String, confidence: Int) {
        var meta = masteryMetadata[id] ?? MasteryMetadata(id: id)
        let today = Calendar.current.startOfDay(for: Date())
        var daysToAdd = 1

        if confidence == 2 {
            meta.confidenceScore += 1
            if meta.status == .new {
                meta.status = .learning
                daysToAdd = 2
            } else if meta.status == .learning {
                if meta.confidenceScore >= 3 {
                    meta.status = .memorized
                    daysToAdd = 7
                } else {
                    daysToAdd = 3
                }
            } else {
                daysToAdd = 10
            }
        } else if confidence == 1 {
            daysToAdd = 1
        } else {
            meta.confidenceScore = 0
            if meta.status == .memorized {
                meta.status = .learning
            }
            daysToAdd = 0
        }

        meta.lastReview = Date()
        meta.nextReview = Calendar.current.date(byAdding: .day, value: daysToAdd, to: today) ?? today
        masteryMetadata[id] = meta
        persistState()
    }

    private func checkHaptic(completed: Bool) {
        if completed {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }

    // MARK: - Auth & Cloud Sync
    func loginOffline() {
        isOfflineMode = true
        isLoggedIn = true
        currentUser = User(name: "Guest", email: "offline@adhkar.ai", isOffline: true)
    }

    func loginReal(email: String, pass: String) async throws {
        let profile = try await SupabaseClient.shared.signIn(email: email, password: pass)
        await MainActor.run {
            self.currentUser = User(name: profile.email.components(separatedBy: "@").first ?? "User", email: profile.email, isOffline: false)
            self.isLoggedIn = true
            self.isOfflineMode = false
        }
        await syncFromCloud()
    }

    func signupReal(email: String, pass: String) async throws {
        let profile = try await SupabaseClient.shared.signUp(email: email, password: pass)
        await MainActor.run {
            self.currentUser = User(name: profile.email.components(separatedBy: "@").first ?? "User", email: profile.email, isOffline: false)
            self.isLoggedIn = true
            self.isOfflineMode = false
        }
        persistState()
    }

    func signInWithApple() async throws {
        let profile = try await AuthService.shared.signInWithApple()
        await MainActor.run {
            self.currentUser = User(
                name: profile.email.components(separatedBy: "@").first ?? "User",
                email: profile.email,
                isOffline: false
            )
            self.isLoggedIn = true
            self.isOfflineMode = false
        }
        await syncFromCloud()
    }

    func logout() {
        SupabaseClient.shared.signOut()
        isLoggedIn = false
        isOfflineMode = false
        currentUser = nil
    }

    func syncFromCloud() async {
        guard SupabaseClient.shared.currentUser != nil, !isOfflineMode else { return }
        
        await MainActor.run { 
            isSyncing = true
            syncStatus = "Restoring..." 
        }
        
        do {
            let rawProgress = try await SupabaseClient.shared.fetchUserProgress()
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            
            await MainActor.run {
                for raw in rawProgress {
                    let st = MasteryStatus(rawValue: raw.level) ?? .new
                    let last = f.date(from: raw.last_updated) ?? Date()
                    let next = f.date(from: raw.next_review) ?? Date()
                    let meta = MasteryMetadata(id: raw.adhkar_id, status: st, nextReview: next, lastReview: last, confidenceScore: Int(raw.streak))
                    self.masteryMetadata[raw.adhkar_id] = meta
                }
            }
            
            if let stats = try await SupabaseClient.shared.fetchUserStats() {
                await MainActor.run {
                    if let data = stats.activity_history.data(using: .utf8),
                       let cloudHistory = try? JSONDecoder().decode([String: DailyProgressEntryProxy].self, from: data) {
                        
                        // Merge Cloud History with Local History (Date-based)
                        let f = DateFormatter()
                        f.dateFormat = "yyyy-MM-dd"
                        
                        // 1. Convert current local progress to a dictionary for easy merging
                        var merged = Dictionary(uniqueKeysWithValues: self.progressHistory.map {
                            (f.string(from: $0.date), $0)
                        })
                        
                        // 2. Overwrite/Add cloud entries (only if they have more/newer info or are missing)
                        for (key, proxy) in cloudHistory {
                            guard let date = f.date(from: key) else { continue }
                            let cloudEntry = DailyProgressEntry(
                                date: date,
                                morningCompleted: proxy.m,
                                eveningCompleted: proxy.e,
                                completionRatio: proxy.r ?? 0
                            )
                            
                            if let existing = merged[key] {
                                // Keep the one with better completion ratio
                                if cloudEntry.completionRatio > existing.completionRatio {
                                    merged[key] = cloudEntry
                                }
                            } else {
                                merged[key] = cloudEntry
                            }
                        }
                        
                        self.progressHistory = Array(merged.values).sorted { $0.date < $1.date }
                    }
                }
            }

            let remoteCustom = try await SupabaseClient.shared.fetchCustomAdhkar()
            let customAsDhikr = remoteCustom.map { raw in
                Dhikr(
                    id: raw.id,
                    arabic: raw.arabic,
                    transliteration: raw.transliteration ?? "",
                    translation: raw.translation ?? "",
                    repetitions: 1,
                    source: raw.source,
                    category: .custom,
                    benefit: raw.benefit,
                    pinTo: raw.pin_to
                )
            }
            
            await MainActor.run {
                self.customAdhkar = customAsDhikr
                isSyncing = false
                syncStatus = "Saved"
                persistState()
                checkDailyReset() // Ensure sync doesn't overwrite a needed reset
            }
        } catch {
            print("⚠️ Sync From Cloud failed: \(error)")
            await MainActor.run { isSyncing = false }
        }
    }

    func syncToCloud() async {
        guard let userProfile = SupabaseClient.shared.currentUser, !isOfflineMode else { return }
        
        await MainActor.run { 
            isSyncing = true
            syncStatus = "Syncing..." 
        }
        
        do {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            let historyProxy = Dictionary(progressHistory.map {
                (f.string(from: $0.date), DailyProgressEntryProxy(m: $0.morningCompleted, e: $0.eveningCompleted, r: $0.completionRatio))
            }, uniquingKeysWith: { (first, _) in first })
            
            let stats = RawUserStats(
                user_id: userProfile.id,
                daily_count: totalDailyCount,
                daily_streak: streakDays,
                last_active_date: f.string(from: Date()),
                activity_history: (try? String(data: JSONEncoder().encode(historyProxy), encoding: .utf8)) ?? "{}",
                total_days_active: totalDaysActive,
                longest_streak: longestStreak
            )
            try await SupabaseClient.shared.upsertUserStats(stats)
            
            let progressRows = masteryMetadata.map { (id, meta) in
                RawUserProgress(
                    user_id: userProfile.id,
                    adhkar_id: id,
                    count: 0,
                    level: meta.status.rawValue,
                    last_updated: f.string(from: meta.lastReview ?? Date()),
                    next_review: f.string(from: meta.nextReview),
                    streak: meta.confidenceScore
                )
            }
            if !progressRows.isEmpty {
                try await SupabaseClient.shared.upsertUserProgress(progressRows)
            }

            let customRows = customAdhkar.map { d in
                RawCustomAdhkar(
                    id: d.id,
                    user_id: userProfile.id,
                    arabic: d.arabic,
                    transliteration: d.transliteration,
                    translation: d.translation,
                    benefit: d.benefit,
                    pin_to: d.pinTo,
                    source: d.source ?? "Custom"
                )
            }
            if !customRows.isEmpty {
                try await SupabaseClient.shared.upsertCustomAdhkar(customRows)
            }
            
            await MainActor.run {
                isSyncing = false
                syncStatus = "Saved"
            }
        } catch {
            print("⚠️ Sync To Cloud failed: \(error)")
            await MainActor.run { 
                isSyncing = false
                syncStatus = "Offline"
            }
        }
    }

    struct DailyProgressEntryProxy: Codable {
        let m: Bool
        let e: Bool
        let r: Double?
    }

    private func upsertTodayProgress() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let newRatio = dailyCompletionRatio
        let mDone = morningAllDone
        let eDone = eveningAllDone

        if let index = progressHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            var existing = progressHistory[index]
            // Preserve 'completed' status once achieved for the day
            existing.morningCompleted = existing.morningCompleted || mDone
            existing.eveningCompleted = existing.eveningCompleted || eDone
            existing.completionRatio = max(existing.completionRatio, newRatio)
            progressHistory[index] = existing
        } else {
            let todayEntry = DailyProgressEntry(
                date: today,
                morningCompleted: mDone,
                eveningCompleted: eDone,
                completionRatio: newRatio
            )
            progressHistory.append(todayEntry)
            progressHistory.sort { $0.date < $1.date }
        }
    }

    private func trimProgressHistory(maxEntries: Int) {
        guard progressHistory.count > maxEntries else { return }
        progressHistory = Array(progressHistory.suffix(maxEntries))
    }

    private func store<T: Codable>(_ value: T, key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }

    private func load<T: Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    // MARK: - Utilities
    func segmentArabicText(_ text: String) -> [DhikrSegment] {
        let words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return words.enumerated().map { (index, word) in
            DhikrSegment(id: index, content: word)
        }
    }

    // MARK: - Settings Persistence
    func resetToDefaults() {
        withAnimation(.spring()) {
            arabicFontSize = 26
            arabicFontName = "System"
            transliterationFontSize = 14
            translationFontSize = 14
            showTransliteration = true
            showTranslation = true
            showSearchBars = true
            themeMode = .auto
            persistState()
        }
    }
}
