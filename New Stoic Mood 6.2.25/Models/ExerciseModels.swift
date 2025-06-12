import Foundation

struct StoicExercise: Identifiable {
    let id: UUID
    let date: Date
    let quote: String
    let author: String
    let exercise: String
    let steps: [String]
}

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
