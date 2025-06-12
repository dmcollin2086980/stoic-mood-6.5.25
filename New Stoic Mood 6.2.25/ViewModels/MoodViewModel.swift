import Foundation
import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var moodEntries: [MoodEntry] = []
    @Published var selectedMood: Mood?
    @Published var selectedIntensity: Int = 3
    @Published var journalEntry: String = ""
    @Published var textAnalysis: TextAnalysis?
    @Published var moodTransitions: [MoodTransition]?
    @Published var timePatterns: [TimePatternData] = []
    @Published var growthInsights: [String]?
    @Published var reflectionQuality: ReflectionQuality?
    @Published var currentStreak: Int = 0
    @Published var moodFlowData: [MoodFlowData] = []

    private let saveKey = "moodEntries"

    init() {
        loadMoodEntries()
        loadData()
    }

    func loadData() {
        print("Loading mood data...")
        print("Loaded \(moodEntries.count) entries")

        analyzeData()
        currentStreak = calculateCurrentStreak()
        calculateMoodFlowData()

        print("Mood data analysis complete")
        print("Current streak: \(currentStreak)")
        print("Mood flow data points: \(moodFlowData.count)")
    }

    private func analyzeData() {
        analyzeText()
        analyzeMoodTransitions()
        analyzeTimePatterns()
        generateGrowthInsights()
        calculateReflectionQuality()
    }

    private func analyzeText() {
        guard !moodEntries.isEmpty else { return }

        let allText = moodEntries.compactMap { $0.journalEntry }.joined(separator: " ")
        let words = allText.split(separator: " ").map(String.init)
        let wordCount = words.count

        // Simple word frequency analysis
        let wordFrequencies = Dictionary(grouping: words, by: { $0.lowercased() })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }

        let topWords = Array(wordFrequencies.prefix(10).map { $0.key })

        textAnalysis = TextAnalysis(
            averageLength: wordCount / moodEntries.count,
            topWords: topWords,
            writingStyle: determineWritingStyle(words: words),
            sentiment: calculateSentimentScore(text: allText),
            themes: identifyThemes(words: words)
        )
    }

    private func analyzeMoodTransitions() {
        guard moodEntries.count >= 2 else { return }

        var transitions: [MoodTransition] = []
        for i in 0..<moodEntries.count - 1 {
            let from = moodEntries[i].mood
            let to = moodEntries[i + 1].mood

            if let index = transitions.firstIndex(where: { $0.from == from && $0.to == to }) {
                transitions[index] = MoodTransition(
                    from: from,
                    to: to,
                    count: transitions[index].count + 1
                )
            } else {
                transitions.append(MoodTransition(from: from, to: to, count: 1))
            }
        }

        moodTransitions = transitions.sorted { $0.count > $1.count }
    }

    private func analyzeTimePatterns() {
        var patterns: [TimePatternData] = []

        // Analyze morning entries
        let morningEntries = moodEntries.filter { entry in
            let hour = Calendar.current.component(.hour, from: entry.timestamp)
            return hour >= 5 && hour < 12
        }

        if !morningEntries.isEmpty {
            patterns.append(TimePatternData(
                icon: "sunrise.fill",
                title: "Morning Reflection",
                description: "You tend to journal in the morning \(String(morningEntries.count)) times",
                hour: 9,
                count: morningEntries.count
            ))
        }

        // Analyze evening entries
        let eveningEntries = moodEntries.filter { entry in
            let hour = Calendar.current.component(.hour, from: entry.timestamp)
            return hour >= 18 && hour < 24
        }

        if !eveningEntries.isEmpty {
            patterns.append(TimePatternData(
                icon: "moon.stars.fill",
                title: "Evening Reflection",
                description: "You tend to journal in the evening \(String(eveningEntries.count)) times",
                hour: 21,
                count: eveningEntries.count
            ))
        }

        timePatterns = patterns
    }

    private func generateGrowthInsights() {
        guard !moodEntries.isEmpty else { return }

        var insights: [String] = []

        // Analyze consistency
        let consistency = calculateConsistency()
        if consistency < 0.5 {
            insights.append("Try to maintain a more consistent journaling schedule")
        }

        // Analyze depth
        let averageLength = moodEntries.compactMap { $0.journalEntry }
            .map { $0.split(separator: " ").count }
            .reduce(0, +) / moodEntries.count
        if averageLength < 50 {
            insights.append("Consider writing longer entries to explore your thoughts more deeply")
        }

        growthInsights = insights
    }

    private func calculateReflectionQuality() {
        guard !moodEntries.isEmpty else { return }

        let averageLength = moodEntries.compactMap { $0.journalEntry }
            .map { $0.split(separator: " ").count }
            .reduce(0, +) / moodEntries.count
        let consistency = calculateConsistency()

        reflectionQuality = ReflectionQuality(
            length: averageLength,
            consistency: Int(consistency * 100),
            feedback: generateFeedback(length: averageLength, consistency: consistency)
        )
    }

    private func calculateMoodFlowData() {
        guard !moodEntries.isEmpty else {
            moodFlowData = []
            return
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        var dataPoints: [MoodFlowData] = []

        // Get all entries from the last 30 days
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today)!
        let recentEntries = moodEntries.filter { $0.timestamp >= thirtyDaysAgo && $0.timestamp <= today }

        // Group entries by day
        let groupedEntries = Dictionary(grouping: recentEntries) { entry in
            calendar.startOfDay(for: entry.timestamp)
        }

        // Create data points for each day
        for dayOffset in 0...30 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!

            if let dayEntries = groupedEntries[date] {
                // Calculate average mood value for the day
                let totalMoodValue = dayEntries.reduce(0) { sum, entry in
                    sum + entry.intensity
                }
                let averageMoodValue = Double(totalMoodValue) / Double(dayEntries.count)

                dataPoints.append(MoodFlowData(
                    date: date,
                    value: averageMoodValue
                ))
            }
        }

        // Sort data points by date
        moodFlowData = dataPoints.sorted { $0.date < $1.date }
        print("Generated \(moodFlowData.count) mood flow data points")
    }

    // MARK: - Helper Methods

    private func determineWritingStyle(words: [String]) -> String {
        let avgWordLength = Double(words.joined().count) / Double(words.count)
        let longWords = words.filter { $0.count > 6 }.count
        let longWordPercentage = Double(longWords) / Double(words.count)

        if avgWordLength > 5 && longWordPercentage > 0.2 {
            return "Reflective and detailed"
        } else if avgWordLength > 4 {
            return "Balanced and thoughtful"
        } else {
            return "Concise and direct"
        }
    }

    private func calculateSentimentScore(text: String) -> Double {
        let positiveWords = ["happy", "joy", "grateful", "peace", "love", "hope", "good", "great", "wonderful"]
        let negativeWords = ["sad", "angry", "frustrated", "anxious", "worried", "bad", "terrible", "awful"]

        let words = text.lowercased().split(separator: " ").map(String.init)
        let positiveCount = words.filter { positiveWords.contains($0) }.count
        let negativeCount = words.filter { negativeWords.contains($0) }.count

        let totalCount = positiveCount + negativeCount
        guard totalCount > 0 else { return 0.5 } // Neutral if no sentiment words found

        return Double(positiveCount) / Double(totalCount)
    }

    private func calculateSentiment(text: String) -> String {
        let score = calculateSentimentScore(text: text)

        if score > 0.7 {
            return "Predominantly positive"
        } else if score < 0.3 {
            return "Predominantly negative"
        } else {
            return "Balanced emotional tone"
        }
    }

    private func identifyThemes(words: [String]) -> [String] {
        let themes = [
            "Work": ["work", "job", "career", "project", "meeting", "deadline"],
            "Relationships": ["friend", "family", "relationship", "love", "partner"],
            "Health": ["health", "exercise", "fitness", "diet", "sleep", "energy"],
            "Personal Growth": ["learn", "grow", "improve", "develop", "skill", "knowledge"],
            "Stress": ["stress", "anxiety", "pressure", "overwhelm", "tired"]
        ]

        var themeCounts: [String: Int] = [:]

        for (theme, keywords) in themes {
            let count = words.filter { keywords.contains($0.lowercased()) }.count
            if count > 0 {
                themeCounts[theme] = count
            }
        }

        return themeCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
    }

    private func calculateConsistency() -> Double {
        guard !moodEntries.isEmpty else { return 0 }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today)!

        let recentEntries = moodEntries.filter { $0.timestamp >= thirtyDaysAgo && $0.timestamp <= today }
        let daysWithEntries = Set(recentEntries.map { calendar.startOfDay(for: $0.timestamp) }).count

        return Double(daysWithEntries) / 30.0
    }

    private func generateFeedback(length: Int, consistency: Double) -> String {
        var feedback: [String] = []

        if length < 50 {
            feedback.append("Try to write longer entries to explore your thoughts more deeply")
        }

        if consistency < 0.5 {
            feedback.append("Aim to journal more consistently")
        }

        if feedback.isEmpty {
            feedback.append("Great job maintaining your journaling practice!")
        }

        return feedback.joined(separator: ". ")
    }

    // MARK: - Data Persistence

    private func loadMoodEntries() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let entries = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            moodEntries = entries
        }
    }

    func saveMoodEntries() {
        if let data = try? JSONEncoder().encode(moodEntries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    // MARK: - Public Methods

    func getMoodStats() -> MoodStats {
        let totalEntries = moodEntries.count
        guard totalEntries > 0 else {
            return MoodStats(
                positivePercentage: 0,
                neutralPercentage: 0,
                negativePercentage: 0,
                mostCommonMood: nil,
                averageIntensity: 0
            )
        }

        var moodDistribution: [MoodCategory: Int] = [:]
        var moodCounts: [Mood: Int] = [:]
        var totalIntensity = 0

        for entry in moodEntries {
            moodDistribution[entry.mood.category, default: 0] += 1
            moodCounts[entry.mood, default: 0] += 1
            totalIntensity += entry.intensity
        }

        let positiveCount = moodDistribution[.positive] ?? 0
        let neutralCount = moodDistribution[.neutral] ?? 0
        let negativeCount = moodDistribution[.negative] ?? 0

        let mostCommonMood = moodCounts.max(by: { $0.value < $1.value })?.key

        return MoodStats(
            positivePercentage: Double(positiveCount) / Double(totalEntries) * 100,
            neutralPercentage: Double(neutralCount) / Double(totalEntries) * 100,
            negativePercentage: Double(negativeCount) / Double(totalEntries) * 100,
            mostCommonMood: mostCommonMood,
            averageIntensity: Double(totalIntensity) / Double(totalEntries)
        )
    }

    func calculateCurrentStreak() -> Int {
        guard !moodEntries.isEmpty else {
            return 0
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentDate = today
        var streak = 0

        // Sort entries by date in descending order
        let sortedEntries = moodEntries.sorted { $0.timestamp > $1.timestamp }

        // Check each day from today backwards
        while true {
            let hasEntry = sortedEntries.contains { entry in
                calendar.isDate(entry.timestamp, inSameDayAs: currentDate)
            }

            if hasEntry {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }

        return streak
    }

    func calculateReflectionStreak() -> Int {
        guard !moodEntries.isEmpty else {
            return 0
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentDate = today
        var streak = 0

        // Sort entries by date in descending order
        let sortedEntries = moodEntries.filter { $0.journalEntry != nil }
            .sorted { $0.timestamp > $1.timestamp }

        // Check each day from today backwards
        while true {
            let hasReflection = sortedEntries.contains { entry in
                calendar.isDate(entry.timestamp, inSameDayAs: currentDate)
            }

            if hasReflection {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }

        return streak
    }
}

struct MoodStats {
    var positivePercentage: Double
    var neutralPercentage: Double
    var negativePercentage: Double
    var mostCommonMood: Mood?
    var averageIntensity: Double
}
