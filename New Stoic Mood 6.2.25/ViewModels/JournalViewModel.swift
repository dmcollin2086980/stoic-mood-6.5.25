import Foundation
import SwiftUI

class JournalViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []
    private let saveKey = "journalEntries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(mood: Mood, intensity: Int, content: String = "") {
        let entry = MoodEntry(
            mood: mood,
            intensity: intensity,
            journalEntry: content.isEmpty ? nil : content
        )
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            entries = decoded
        } else {
            // Load sample data if no saved entries exist
            entries = MoodEntry.sampleEntries
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries.remove(at: index)
            saveEntries()
        }
    }
    
    func updateEntry(_ entry: MoodEntry, newMood: Mood? = nil, newIntensity: Int? = nil, newContent: String? = nil) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            let updatedEntry = MoodEntry(
                id: entry.id,
                mood: newMood ?? entry.mood,
                intensity: newIntensity ?? entry.intensity,
                timestamp: entry.timestamp,
                journalEntry: newContent ?? entry.journalEntry
            )
            entries[index] = updatedEntry
            saveEntries()
        }
    }
}

