import Foundation
import SwiftUI

class ExerciseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var dailyExercise: StoicExercise?
    @Published var exerciseHistory: [ExerciseEntry] = []
    
    // MARK: - Initialization
    init() {
        loadData()
        generateDailyExercise()
    }
    
    // MARK: - Data Management
    func clearAllData() {
        exerciseHistory.removeAll()
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
        // Implementation for loading data from storage
    }
    
    private func saveData() {
        // Implementation for saving data to storage
    }
} 