import Foundation
import SwiftUI

struct ExerciseEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let prompt: String
    let response: String
    let timestamp: Date
    
    init(id: UUID = UUID(), date: Date = Date(), prompt: String, response: String, timestamp: Date = Date()) {
        self.id = id
        self.date = date
        self.prompt = prompt
        self.response = response
        self.timestamp = timestamp
    }
}

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [ExerciseEntry] = []
    private let userDefaults = UserDefaults.standard
    private let exercisesKey = "SavedExercises"
    
    init() {
        loadExercises()
    }
    
    public func addExercise(date: Date, prompt: String, response: String) {
        let entry = ExerciseEntry(date: date, prompt: prompt, response: response)
        exercises.insert(entry, at: 0)
        saveExercises()
    }
    
    public func clearAll() {
        exercises.removeAll()
        saveExercises()
    }
    
    public func saveExercises() {
        if let encoded = try? JSONEncoder().encode(exercises) {
            userDefaults.set(encoded, forKey: exercisesKey)
        }
    }
    
    private func loadExercises() {
        if let data = userDefaults.data(forKey: exercisesKey),
           let decoded = try? JSONDecoder().decode([ExerciseEntry].self, from: data) {
            exercises = decoded.sorted { $0.date > $1.date }
        }
    }
} 