// AppState.swift — Central state management (ObservableObject)

import SwiftUI
import Combine

class AppState: ObservableObject {
    private enum StorageKey {
        static let morningAdhkar = "adhkar.morning"
        static let eveningAdhkar = "adhkar.evening"
        static let progressHistory = "adhkar.progressHistory"
        static let themeMode = "adhkar.themeMode"
        static let masteryMetadata = "adhkar.masteryMetadata"
        static let dailyCategories = "adhkar.dailyCategories"
        static let customAdhkar = "adhkar.custom"
        static let arabicFontSize = "adhkar.arabicFontSize"
        static let arabicFontName = "adhkar.arabicFontName"
        static let showTransliteration = "adhkar.showTransliteration"
        static let showTranslation = "adhkar.showTranslation"
        static let arabicLineSpacing = "adhkar.arabicLineSpacing"
        static let hasCompletedOnboarding = "adhkar.hasCompletedOnboarding"
        static let hasCompletedTour = "adhkar.hasCompletedTour"
    }

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

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

    // MARK: - Theme & Visuals
    @Published var themeMode: ThemeMode = .auto {
        didSet {
            defaults.set(themeMode.rawValue, forKey: StorageKey.themeMode)
            objectWillChange.send() // Ensure full UI refresh on theme change
        }
    }

    @Published var arabicFontSize: Double = 26 {
        didSet {
            defaults.set(arabicFontSize, forKey: StorageKey.arabicFontSize)
            objectWillChange.send()
        }
    }

    @Published var arabicLineSpacing: Double = 8 {
        didSet {
            defaults.set(arabicLineSpacing, forKey: StorageKey.arabicLineSpacing)
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
    
    @Published var customAdhkar: [Dhikr] = [] {
        didSet {
            // Sync customAdhkar into dailyCategories [.custom] entry
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
                // Check if already in persisted state, otherwise use default
                return DailyCategory(category: cat, adhkar: AdhkarData.adhkar(for: cat))
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
    // (Existing percentage and streak vars go here...)
    
    var morningCompleted: Int { morningAdhkar.filter(\.isCompleted).count }
    var morningTotal: Int { morningAdhkar.filter(\.isVisible).count }
    var morningAllDone: Bool { morningCompleted >= morningTotal && morningTotal > 0 }

    var eveningCompleted: Int { eveningAdhkar.filter(\.isCompleted).count }
    var eveningTotal: Int { eveningAdhkar.filter(\.isVisible).count }
    var eveningAllDone: Bool { eveningCompleted >= eveningTotal && eveningTotal > 0 }

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
    private func persistState() {
        store(morningAdhkar, key: StorageKey.morningAdhkar)
        store(eveningAdhkar, key: StorageKey.eveningAdhkar)
        store(dailyCategories, key: StorageKey.dailyCategories)
        store(customAdhkar, key: StorageKey.customAdhkar)
        store(masteryMetadata, key: StorageKey.masteryMetadata)
        upsertTodayProgress()
        trimProgressHistory(maxEntries: 180)
        store(progressHistory, key: StorageKey.progressHistory)
        defaults.set(hasCompletedOnboarding, forKey: StorageKey.hasCompletedOnboarding)
        defaults.set(hasCompletedTour, forKey: StorageKey.hasCompletedTour)
        
        Task {
            await syncToCloud()
        }
    }

    private func loadPersistedState() {
        if let storedMorning: [Dhikr] = load(forKey: StorageKey.morningAdhkar) {
            morningAdhkar = storedMorning
        }
        if let storedEvening: [Dhikr] = load(forKey: StorageKey.eveningAdhkar) {
            eveningAdhkar = storedEvening
        }
        if let storedDaily: [DailyCategory] = load(forKey: StorageKey.dailyCategories) {
            dailyCategories = storedDaily
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
        
        let savedSpacing = defaults.double(forKey: StorageKey.arabicLineSpacing)
        if savedSpacing > 0 { arabicLineSpacing = savedSpacing }
        
        if let savedFont = defaults.string(forKey: StorageKey.arabicFontName) {
            arabicFontName = savedFont
        }
        
        if defaults.object(forKey: StorageKey.showTransliteration) != nil {
            showTransliteration = defaults.bool(forKey: StorageKey.showTransliteration)
        }
        
        if defaults.object(forKey: StorageKey.showTranslation) != nil {
            showTranslation = defaults.bool(forKey: StorageKey.showTranslation)
        }
        
        hasCompletedOnboarding = defaults.bool(forKey: StorageKey.hasCompletedOnboarding)
        hasCompletedTour = defaults.bool(forKey: StorageKey.hasCompletedTour)
        
        setupCategories() // Re-sync categories list
    }

    var totalDaysActive: Int {
        progressHistory.filter { $0.completionRatio > 0 }.count
    }
    
    var longestStreak: Int {
        // Placeholder for now, could be calculated or synced
        streakDays 
    }

    // Percentage helpers for Progress page
    var morningProgressPct: Int {
        let total = morningAdhkar.filter(\.isVisible).count
        guard total > 0 else { return 0 }
        let completed = morningAdhkar.filter(\.isCompleted).count
        return Int(Double(completed) / Double(total) * 100)
    }
    
    var eveningProgressPct: Int {
        let total = eveningAdhkar.filter(\.isVisible).count
        guard total > 0 else { return 0 }
        let completed = eveningAdhkar.filter(\.isCompleted).count
        return Int(Double(completed) / Double(total) * 100)
    }
    
    var dailyProgressPct: Int {
        let allDaily = dailyCategories.flatMap { $0.adhkar }.filter(\.isVisible)
        guard !allDaily.isEmpty else { return 0 }
        let completed = allDaily.filter(\.isCompleted).count
        return Int(Double(completed) / Double(allDaily.count) * 100)
    }

    var overallMasteryPct: Int {
        let allItems = (morningAdhkar + eveningAdhkar).filter(\.isVisible).count + 
                      dailyCategories.flatMap { $0.adhkar }.filter(\.isVisible).count
        guard allItems > 0 else { return 0 }
        return Int(Double(memorizedCount) / Double(allItems) * 100)
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
                // If it's today and not done yet, don't break the streak yet, but don't count it as a "completed" day in the loop
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

    // MARK: - Edit Mode (toggled via pencil button)
    @Published var isMorningEditMode: Bool = false
    @Published var isEveningEditMode: Bool = false

    init() {
        loadPersistedState()
        persistState()
    }

    // MARK: - Reset (daily reset at midnight)
    func resetMorning() {
        for i in morningAdhkar.indices { morningAdhkar[i].reset() }
        persistState()
    }

    func resetEvening() {
        for i in eveningAdhkar.indices { eveningAdhkar[i].reset() }
        persistState()
    }

    // MARK: - Increment dhikr
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

    // MARK: - Toggle visibility
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

        if confidence == 2 { // Yes
            meta.confidenceScore += 1 // Using as streak
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
            } else { // memorized
                daysToAdd = 10
            }
        } else if confidence == 1 { // Almost
            daysToAdd = 1
        } else { // No
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

    // MARK: - Arabic Text Segmentation
    func segmentArabicText(_ text: String) -> [DhikrSegment] {
        // More robust segmentation using common Arabic punctuation for natural breaks
        // Characters: ، (comma), ؛ (semicolon), . (period), ؟ (question), ۝ (Ayah end)
        let punctuationPattern = "[،؛.؟۝]"
        var segments: [DhikrSegment] = []
        
        // Use a scanner or manual split to keep delimiters or split by them
        // For simplicity, we'll split by spaces but look for punctuation-ended words
        let rawWords = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        var currentChunk: [String] = []
        var segmentId = 0
        
        for word in rawWords {
            currentChunk.append(word)
            
            // Check if word ends with punctuation or chunk is large enough (3-4 words)
            let hasPunctuation = word.range(of: punctuationPattern, options: .regularExpression) != nil
            
            if hasPunctuation || currentChunk.count >= 4 {
                segments.append(DhikrSegment(id: segmentId, content: currentChunk.joined(separator: " ")))
                currentChunk = []
                segmentId += 1
            }
        }
        
        if !currentChunk.isEmpty {
            segments.append(DhikrSegment(id: segmentId, content: currentChunk.joined(separator: " ")))
        }
        
        return segments
    }

    // MARK: - Haptic
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
        currentUser = User(name: "Offline Explorer", email: "offline@adhkar.ai", isOffline: true)
    }

    func loginReal(email: String, pass: String) async throws {
        let profile = try await SupabaseClient.shared.signIn(email: email, password: pass)
        await MainActor.run {
            self.currentUser = User(name: profile.email.components(separatedBy: "@").first ?? "User", email: profile.email, isOffline: false)
            self.isLoggedIn = true
            self.isOfflineMode = false
        }
        try await pullInitialData()
    }

    func signupReal(email: String, pass: String) async throws {
        let profile = try await SupabaseClient.shared.signUp(email: email, password: pass)
        await MainActor.run {
            self.currentUser = User(name: profile.email.components(separatedBy: "@").first ?? "User", email: profile.email, isOffline: false)
            self.isLoggedIn = true
            self.isOfflineMode = false
        }
        // New user starts fresh or with default
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
        // Sync existing cloud data for this Apple user
        await syncFromCloud()
    }

    func logout() {
        SupabaseClient.shared.signOut()
        isLoggedIn = false
        isOfflineMode = false
        currentUser = nil
    }

    func pullInitialData() async throws {
        guard let user = SupabaseClient.shared.currentUser else { return }
        
        let cloudProgress = try await SupabaseClient.shared.fetchUserProgress()
        let cloudStats = try await SupabaseClient.shared.fetchUserStats()
        
        await MainActor.run {
            // Apply Cloud Progress
            for row in cloudProgress {
                if let id = UUID(uuidString: row.adhkar_id) {
                    var meta = self.masteryMetadata[id] ?? MasteryMetadata(id: id)
                    meta.status = MasteryStatus(rawValue: row.level) ?? .new
                let id = row.adhkar_id
                var meta = self.masteryMetadata[id] ?? MasteryMetadata(id: id)
                meta.status = MasteryStatus(rawValue: row.level) ?? .new
                meta.confidenceScore = row.streak
                
                let f = DateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                meta.nextReview = f.date(from: row.next_review) ?? Date()
                meta.lastReview = f.date(from: row.last_updated) ?? Date()
                
                self.masteryMetadata[id] = meta
            }
            
            // Apply Cloud Stats (Activity History)
            if let stats = cloudStats {
                if let data = stats.activity_history.data(using: .utf8),
                   let history: [String: DailyProgressEntryProxy] = try? JSONDecoder().decode([String: DailyProgressEntryProxy].self, from: data) {
                    
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd"
                    
                    self.progressHistory = history.compactMap { (key, proxy) -> DailyProgressEntry? in
                        guard let date = f.date(from: key) else { return nil }
                        return DailyProgressEntry(
                            date: date,
                            morningCompleted: proxy.m,
                            eveningCompleted: proxy.e,
                            completionRatio: proxy.r ?? 0
                        )
                    }.sorted { $0.date < $1.date }
                }
            }
            
            self.loadPersistedState() // Merge with local if needed, but cloud is priority here
            self.persistState()
        }
    }

    func syncFromCloud() async {
        guard let user = SupabaseClient.shared.currentUser, !isOfflineMode else { return }
        
        await MainActor.run { 
            isSyncing = true
            syncStatus = "Restoring..." 
        }
        
        do {
            // 1. Fetch Mastery
            let rawProgress = try await SupabaseClient.shared.fetchUserProgress()
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            
            await MainActor.run {
                for raw in rawProgress {
                    let st = MasteryStatus(rawValue: raw.level) ?? .new
                    let last = f.date(from: raw.last_updated) ?? Date()
                    let next = f.date(from: raw.next_review) ?? Date()
                    let meta = MasteryMetadata(id: raw.adhkar_id, status: st, lastReview: last, nextReview: next, confidenceScore: raw.streak)
                    self.masteryMetadata[raw.adhkar_id] = meta
                }
            }
            
            // 2. Fetch Stats & History
            if let stats = try await SupabaseClient.shared.fetchUserStats() {
                await MainActor.run {
                    if let data = stats.activity_history.data(using: .utf8),
                       let history = try? JSONDecoder().decode([String: DailyProgressEntryProxy].self, from: data) {
                        self.progressHistory = history.compactMap { (key, proxy) -> DailyProgressEntry? in
                            guard let date = f.date(from: key) else { return nil }
                            return DailyProgressEntry(date: date, morningCompleted: proxy.m, eveningCompleted: proxy.e, completionRatio: proxy.r ?? 0)
                        }.sorted { $0.date < $1.date }
                    }
                }
            }

            // 3. Fetch Custom Adhkar (Library)
            let remoteCustom = try await SupabaseClient.shared.fetchCustomAdhkar()
            let customAsDhikr = remoteCustom.map { raw in
                Dhikr(
                    id: raw.id,
                    arabic: raw.arabic,
                    transliteration: raw.transliteration ?? "",
                    translation: raw.translation ?? "",
                    repetitions: 1, // Default to 1 from remote if not stored separately
                    source: raw.source,
                    category: .custom,
                    benefit: raw.benefit,
                    pinTo: raw.pin_to
                )
            }
            
            await MainActor.run {
                // Merge logic: prefer cloud contents for existing IDs
                self.customAdhkar = customAsDhikr
                self.loadPersistedState() // Merge with local if needed
                self.persistState()
                isSyncing = false
                syncStatus = "Saved"
            }
        } catch {
            print("⚠️ Sync From Cloud failed: \(error)")
            await MainActor.run { isSyncing = false }
        }
    }

    func syncToCloud() async {
        guard let user = SupabaseClient.shared.currentUser, !isOfflineMode else { return }
        
        await MainActor.run { 
            isSyncing = true
            syncStatus = "Syncing..." 
        }
        
        do {
            // 1. Sync Stats
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            let historyProxy = Dictionary(uniqueKeysWithValues: progressHistory.map {
                (f.string(from: $0.date), DailyProgressEntryProxy(m: $0.morningCompleted, e: $0.eveningCompleted, r: $0.completionRatio))
            })
            
            let stats = RawUserStats(
                user_id: user.id,
                daily_count: totalDailyCount,
                daily_streak: streakDays,
                last_active_date: f.string(from: Date()),
                activity_history: (try? String(data: JSONEncoder().encode(historyProxy), encoding: .utf8)) ?? "{}",
                total_days_active: totalDaysActive,
                longest_streak: longestStreak
            )
            try await SupabaseClient.shared.upsertUserStats(stats)
            
            // 2. Sync Mastery (Progress)
            let progressRows = masteryMetadata.map { (id, meta) in
                RawUserProgress(
                    user_id: user.id,
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

            // 3. Sync Custom Adhkar
            let customRows = customAdhkar.map { d in
                RawCustomAdhkar(
                    id: d.id,
                    user_id: user.id,
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
        
        do {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"
            
            // 1. Prepare Mastery Progress
            let progressRows = masteryMetadata.map { (id, meta) in
                RawUserProgress(
                    user_id: user.id,
                    adhkar_id: id,
                    count: 0,
                    level: meta.status.rawValue,
                    last_updated: f.string(from: meta.lastReview),
                    next_review: f.string(from: meta.nextReview),
                    streak: meta.confidenceScore
                )
            }
            
            // 2. Prepare Stats & Activity History
            var historyMap: [String: DailyProgressEntryProxy] = [:]
            for entry in progressHistory {
                let key = f.string(from: entry.date)
                historyMap[key] = DailyProgressEntryProxy(m: entry.morningCompleted, e: entry.eveningCompleted, r: entry.completionRatio)
            }
            
            let historyJSON = String(data: (try? JSONEncoder().encode(historyMap)) ?? Data(), encoding: .utf8) ?? "{}"
            
            let stats = RawUserStats(
                user_id: user.id,
                daily_count: morningCompleted + eveningCompleted,
                daily_streak: streakDays,
                last_active_date: f.string(from: Date()),
                activity_history: historyJSON,
                total_days_active: totalDaysActive,
                longest_streak: longestStreak
            )
            
            // Push to Supabase
            try await SupabaseClient.shared.upsertUserProgress(progressRows)
            try await SupabaseClient.shared.upsertUserStats(stats)
            
            await MainActor.run { 
                isSyncing = false
                syncStatus = "Saved" 
            }
        } catch {
            print("⚠️ Sync failed: \(error)")
            await MainActor.run { 
                isSyncing = false
                syncStatus = "Error"
            }
        }
    }

    // Proxy for JSON history
    struct DailyProgressEntryProxy: Codable {
        let m: Bool
        let e: Bool
        let r: Double?
    }

    private func persistState() {
        store(morningAdhkar, key: StorageKey.morningAdhkar)
        store(eveningAdhkar, key: StorageKey.eveningAdhkar)
        store(dailyAdhkarStore, key: StorageKey.dailyAdhkarStore)
        store(masteryMetadata, key: StorageKey.masteryMetadata)
        upsertTodayProgress()
        trimProgressHistory(maxEntries: 180)
        store(progressHistory, key: StorageKey.progressHistory)
        
        // Trigger Cloud Sync
        Task {
            await syncToCloud()
        }
    }

    private func loadPersistedState() {
        if let storedMorning: [Dhikr] = load(forKey: StorageKey.morningAdhkar) {
            morningAdhkar = storedMorning
        }
        if let storedEvening: [Dhikr] = load(forKey: StorageKey.eveningAdhkar) {
            eveningAdhkar = storedEvening
        }
        if let storedDaily: [String: [Dhikr]] = load(forKey: StorageKey.dailyAdhkarStore) {
            dailyAdhkarStore = storedDaily
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
    }

    private func upsertTodayProgress() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let todayEntry = DailyProgressEntry(
            date: today,
            morningCompleted: morningAllDone,
            eveningCompleted: eveningAllDone,
            completionRatio: dailyCompletionRatio
        )

        if let index = progressHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            progressHistory[index] = todayEntry
        } else {
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
}
