import Foundation

struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let mood: Mood
    let intensity: Int // 1-5 scale
    let timestamp: Date
    let journalEntry: String?
    
    init(id: UUID = UUID(), mood: Mood, intensity: Int = 3, timestamp: Date = Date(), journalEntry: String? = nil) {
        self.id = id
        self.mood = mood
        self.intensity = max(1, min(5, intensity)) // Ensure intensity is between 1 and 5
        self.timestamp = timestamp
        self.journalEntry = journalEntry
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var formattedIntensity: String {
        return String(repeating: "⭐️", count: intensity)
    }
}

// MARK: - Sample Data
extension MoodEntry {
    static let sampleEntries: [MoodEntry] = [
        MoodEntry(mood: .happy, intensity: 4, timestamp: Date().addingTimeInterval(-86400), journalEntry: "Had a great day at work!"),
        MoodEntry(mood: .calm, intensity: 3, timestamp: Date().addingTimeInterval(-172800), journalEntry: "Meditation session was very peaceful."),
        MoodEntry(mood: .grateful, intensity: 5, timestamp: Date().addingTimeInterval(-259200), journalEntry: "Feeling thankful for my family and friends.")
    ]
}

enum MoodType: String, Codable, CaseIterable {
    case happy
    case grateful
    case focused
    case anxious
    case frustrated
    case sad
    case calm
    case energetic
    case proud
    case reflective
    case stressed
    
    var emoji: String {
        switch self {
        case .happy: return "😀"
        case .grateful: return "🙏"
        case .focused: return "🎯"
        case .anxious: return "😰"
        case .frustrated: return "😤"
        case .sad: return "😞"
        case .calm: return "🧘"
        case .energetic: return "⚡"
        case .proud: return "🎉"
        case .reflective: return "🥲"
        case .stressed: return "😵‍💫"
        }
    }
    
    var value: Int {
        switch self {
        case .happy: return 5
        case .grateful: return 5
        case .focused: return 4
        case .anxious: return 2
        case .frustrated: return 2
        case .sad: return 1
        case .calm: return 4
        case .energetic: return 4
        case .proud: return 5
        case .reflective: return 3
        case .stressed: return 2
        }
    }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    /// Converts this MoodType to a Mood
    var toMood: Mood {
        switch self {
        case .happy: return .happy
        case .grateful: return .grateful
        case .focused: return .focused
        case .anxious: return .anxious
        case .frustrated: return .frustrated
        case .sad: return .sad
        case .calm: return .calm
        case .energetic: return .energetic
        case .proud: return .proud
        case .reflective: return .reflective
        case .stressed: return .stressed
        }
    }
}

