//
//  New_Stoic_Mood_6_2_25Tests.swift
//  New Stoic Mood 6.2.25Tests
//
//  Created by Daniel Collinsworth on 6/2/25.
//

import XCTest
@testable import New_Stoic_Mood_6_2_25

final class New_Stoic_Mood_6_2_25Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Ensure a clean state for each test
        UserDefaults.standard.removeObject(forKey: "journalEntries")
    }

    func testJournalViewModelEntryManagement() {
        let viewModel = JournalViewModel()
        let initialCount = viewModel.entries.count

        // Add an entry
        viewModel.addEntry(mood: .happy, intensity: 5, content: "Testing entry")
        XCTAssertEqual(viewModel.entries.count, initialCount + 1)
        XCTAssertEqual(viewModel.entries.first?.mood, .happy)
        XCTAssertEqual(viewModel.entries.first?.intensity, 5)
        XCTAssertEqual(viewModel.entries.first?.journalEntry, "Testing entry")

        // Update the entry
        if let entry = viewModel.entries.first {
            viewModel.updateEntry(entry, newMood: .sad, newIntensity: 1, newContent: "Updated")
            let updated = viewModel.entries.first
            XCTAssertEqual(updated?.mood, .sad)
            XCTAssertEqual(updated?.intensity, 1)
            XCTAssertEqual(updated?.journalEntry, "Updated")

            // Delete the entry
            viewModel.deleteEntry(entry)
            XCTAssertEqual(viewModel.entries.count, initialCount)
            XCTAssertFalse(viewModel.entries.contains(where: { $0.id == entry.id }))
        } else {
            XCTFail("Entry should exist after adding")
        }
    }

    func testJournalAnalysisAnalyze() {
        let entries = [
            MoodEntry(mood: .happy, intensity: 4, journalEntry: "Work is good and I love my job"),
            MoodEntry(mood: .sad, intensity: 2, journalEntry: "Family is good and I love my family"),
            MoodEntry(mood: .calm, intensity: 3, journalEntry: "I feel great and love my life")
        ]

        let analysis = JournalAnalysis.analyze(entries: entries)

        XCTAssertEqual(analysis.wordCount, 23)
        XCTAssertEqual(analysis.averageLength, 7)
        XCTAssertEqual(analysis.writingStyle, "Concise and direct")
        XCTAssertEqual(analysis.emotionalTone, "Predominantly positive")
        XCTAssertEqual(analysis.commonThemes, ["Relationships", "Work"])
        XCTAssertEqual(analysis.topWords.first, "love")
    }
}
