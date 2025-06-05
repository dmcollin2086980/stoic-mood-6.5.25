import Foundation

struct Reflection: Identifiable, Codable {
    let id: UUID
    let date: Date
    let content: String
    
    init(id: UUID = UUID(), date: Date = Date(), content: String) {
        self.id = id
        self.date = date
        self.content = content
    }
} 