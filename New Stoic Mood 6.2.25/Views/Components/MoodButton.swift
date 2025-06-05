import SwiftUI

struct MoodButton: View {
    let mood: Any
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var emoji: String {
        if let moodType = mood as? MoodType {
            return moodType.emoji
        } else if let mood = mood as? Mood {
            return mood.emoji
        }
        return "😐"
    }
    
    private var displayName: String {
        if let moodType = mood as? MoodType {
            return moodType.displayName
        } else if let mood = mood as? Mood {
            return mood.rawValue
        }
        return "Unknown"
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 32))
                
                Text(displayName)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(themeManager.padding)
            .background(isSelected ? themeManager.accentColor.opacity(0.2) : themeManager.cardBackgroundColor)
            .cornerRadius(ThemeManager.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                    .stroke(isSelected ? themeManager.accentColor : themeManager.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MoodButton(
            mood: MoodType.calm,
            isSelected: true,
            action: {}
        )
        
        MoodButton(
            mood: Mood.happy,
            isSelected: false,
            action: {}
        )
    }
    .environmentObject(ThemeManager())
    .padding()
} 