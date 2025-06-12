import Foundation

struct Reflection: Identifiable, Codable {
    let id: UUID
    let date: Date
    let content: String
    let exercisePrompt: String

    init(id: UUID = UUID(), date: Date = Date(), content: String, exercisePrompt: String) {
        self.id = id
        self.date = date
        self.content = content
        self.exercisePrompt = exercisePrompt
    }
}
