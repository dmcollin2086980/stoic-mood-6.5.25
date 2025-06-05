import Foundation

/// Represents a mood that can be selected by the user
enum Mood: String, CaseIterable, Identifiable, Codable {
    // Descriptive moods
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
    
    // Quick emoji moods
    case joyful
    case peaceful
    case excited
    case tired
    case confused
    case angry
    case loved
    case inspired
    case bored
    case hopeful
    case overwhelmed
    case content
    case nervous
    case motivated
    case disappointed
    case grateful_emoji
    case zen
    
    /// A unique identifier for the mood
    var id: String { rawValue }
    
    /// The display name of the mood
    var name: String {
        switch self {
        // Descriptive moods
        case .happy: return "Happy"
        case .grateful: return "Grateful"
        case .focused: return "Focused"
        case .anxious: return "Anxious"
        case .frustrated: return "Frustrated"
        case .sad: return "Sad"
        case .calm: return "Calm"
        case .energetic: return "Energetic"
        case .proud: return "Proud"
        case .reflective: return "Reflective"
        case .stressed: return "Stressed"
        
        // Quick emoji moods
        case .joyful: return "Joyful"
        case .peaceful: return "Peaceful"
        case .excited: return "Excited"
        case .tired: return "Tired"
        case .confused: return "Confused"
        case .angry: return "Angry"
        case .loved: return "Loved"
        case .inspired: return "Inspired"
        case .bored: return "Bored"
        case .hopeful: return "Hopeful"
        case .overwhelmed: return "Overwhelmed"
        case .content: return "Content"
        case .nervous: return "Nervous"
        case .motivated: return "Motivated"
        case .disappointed: return "Disappointed"
        case .grateful_emoji: return "Grateful"
        case .zen: return "Zen"
        }
    }
    
    /// The emoji representation of the mood
    var emoji: String {
        switch self {
        // Descriptive moods
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
        
        // Quick emoji moods
        case .joyful: return "😊"
        case .peaceful: return "😌"
        case .excited: return "🥳"
        case .tired: return "😴"
        case .confused: return "🤔"
        case .angry: return "😠"
        case .loved: return "🥰"
        case .inspired: return "✨"
        case .bored: return "😑"
        case .hopeful: return "🤗"
        case .overwhelmed: return "😭"
        case .content: return "😊"
        case .nervous: return "😰"
        case .motivated: return "💪"
        case .disappointed: return "😢"
        case .grateful_emoji: return "🙏"
        case .zen: return "😇"
        }
    }
    
    /// The category of the mood
    var category: MoodCategory {
        switch self {
        case .happy, .joyful, .excited, .proud, .loved, .content, .grateful, .grateful_emoji:
            return .positive
        case .sad, .anxious, .frustrated, .stressed, .tired, .angry, .overwhelmed, .disappointed:
            return .negative
        case .focused, .calm, .energetic, .reflective, .peaceful, .confused, .inspired, .bored, .hopeful, .nervous, .motivated, .zen:
            return .neutral
        }
    }
    
    /// Converts this Mood to a MoodType
    var toMoodType: MoodType {
        switch self {
        case .happy: return .happy
        case .grateful, .grateful_emoji: return .grateful
        case .focused: return .focused
        case .anxious, .nervous: return .anxious
        case .frustrated, .angry: return .frustrated
        case .sad, .disappointed: return .sad
        case .calm, .peaceful, .zen: return .calm
        case .energetic, .motivated: return .energetic
        case .proud, .excited: return .proud
        case .reflective, .inspired: return .reflective
        case .stressed, .overwhelmed: return .stressed
        default: return .happy // Default for new moods
        }
    }
}

/// Represents the category of a mood
enum MoodCategory: String {
    case positive
    case negative
    case neutral
} 