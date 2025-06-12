import Foundation
import SwiftUI

class ExerciseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var dailyExercise: StoicExercise?
    @Published var exerciseHistory: [ExerciseEntry] = []
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let exerciseHistoryKey = "SavedExerciseHistory"
    
    // MARK: - Initialization
    init() {
        loadData()
        generateDailyExercise()
    }
    
    // MARK: - Data Management
    /// Removes all exercise history entries and saves the changes
    public func clearAll() {
        exerciseHistory.removeAll()
        saveData()
    }
    
    /// Adds a new exercise entry to the history
    /// - Parameters:
    ///   - date: The date of the exercise
    ///   - prompt: The exercise prompt
    ///   - response: The user's response to the exercise
    public func addExercise(date: Date, prompt: String, response: String) {
        let entry = ExerciseEntry(
            id: UUID(),
            date: date,
            prompt: prompt,
            response: response,
            timestamp: Date()
        )
        exerciseHistory.insert(entry, at: 0)
        saveData()
    }
    
    // MARK: - Private Methods
    private func generateDailyExercise() {
        let exercises = [
            StoicExercise(
                id: UUID(),
                date: Date(),
                quote: "The happiness of your life depends upon the quality of your thoughts.",
                author: "Marcus Aurelius",
                exercise: "Practice negative visualization by imagining the loss of something you value. This exercise helps cultivate gratitude and resilience.",
                steps: [
                    "Choose something you value (e.g., health, relationships, career)",
                    "Imagine it being taken away",
                    "Reflect on how you would cope",
                    "Appreciate what you have now",
                    "Write down your insights"
                ]
            ),
            StoicExercise(
                id: UUID(),
                date: Date(),
                quote: "We suffer more in imagination than in reality.",
                author: "Seneca",
                exercise: "Challenge your assumptions about what you fear. This exercise helps reduce anxiety and build resilience.",
                steps: [
                    "Identify a current worry or fear",
                    "Question its likelihood and impact",
                    "Consider the worst-case scenario",
                    "Plan how you would handle it",
                    "Take action to reduce the risk"
                ]
            ),
            StoicExercise(
                id: UUID(),
                date: Date(),
                quote: "The obstacle is the way.",
                author: "Epictetus",
                exercise: "Embrace challenges as opportunities for growth. This exercise helps develop resilience and problem-solving skills.",
                steps: [
                    "Identify a current obstacle or challenge",
                    "Reframe it as an opportunity",
                    "Break it down into manageable steps",
                    "Take the first step forward",
                    "Reflect on what you learned"
                ]
            )
        ]
        
        dailyExercise = exercises.randomElement()
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: exerciseHistoryKey),
           let decoded = try? JSONDecoder().decode([ExerciseEntry].self, from: data) {
            exerciseHistory = decoded.sorted { $0.date > $1.date }
        }
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(exerciseHistory) {
            userDefaults.set(encoded, forKey: exerciseHistoryKey)
        }
    }
} 
