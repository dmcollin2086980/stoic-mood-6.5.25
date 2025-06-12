import SwiftUI

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.name)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                    .fill(isSelected ? 
                        themeManager.accentColor.opacity(0.2) : 
                        themeManager.cardBackgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                    .stroke(isSelected ? 
                        themeManager.accentColor : 
                        themeManager.borderColor, 
                        lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        MoodButton(
            mood: .happy,
            isSelected: true,
            action: {}
        )
        
        MoodButton(
            mood: .calm,
            isSelected: false,
            action: {}
        )
    }
    .environmentObject(ThemeManager())
    .padding()
} 
