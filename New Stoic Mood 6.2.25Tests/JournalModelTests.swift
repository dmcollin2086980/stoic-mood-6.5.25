import XCTest
@testable import New_Stoic_Mood_6_2_25

final class JournalModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Ensure a clean state for UserDefaults
        UserDefaults.standard.removeObject(forKey: "journalEntries")
    }

    func testAddAndDeleteEntry() {
        let viewModel = JournalViewModel()
        viewModel.entries = []

        viewModel.addEntry(mood: .happy, intensity: 5, content: "Hello")
        XCTAssertEqual(viewModel.entries.count, 1)

        let entry = viewModel.entries.first!
        XCTAssertEqual(entry.mood, .happy)
        XCTAssertEqual(entry.intensity, 5)
        XCTAssertEqual(entry.journalEntry, "Hello")

        viewModel.deleteEntry(entry)
        XCTAssertTrue(viewModel.entries.isEmpty)
    }

    func testUpdateEntry() {
        let viewModel = JournalViewModel()
        viewModel.entries = []

        viewModel.addEntry(mood: .sad, intensity: 2, content: "Old")
        let entry = viewModel.entries.first!

        viewModel.updateEntry(entry, newMood: .calm, newIntensity: 4, newContent: "Updated")

        let updated = viewModel.entries.first!
        XCTAssertEqual(updated.mood, .calm)
        XCTAssertEqual(updated.intensity, 4)
        XCTAssertEqual(updated.journalEntry, "Updated")
    }

    func testJournalAnalysisMetrics() {
        let entries = [
            MoodEntry(mood: .happy, intensity: 3, journalEntry: "I feel happy and energetic today. happy energy"),
            MoodEntry(mood: .sad, intensity: 2, journalEntry: "I feel sad yet hopeful. sad day")
        ]

        let analysis = JournalAnalysis.analyze(entries: entries)

        XCTAssertEqual(analysis.wordCount, 15)
        XCTAssertEqual(analysis.averageLength, 7)
        XCTAssertTrue(analysis.topWords.contains("happy"))
        XCTAssertTrue(analysis.topWords.contains("sad"))
    }
}
