import SwiftUI

struct ThemeToggle: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button {
            themeManager.toggleTheme()
        } label: {
            HStack {
                Image(systemName: themeManager.isDarkMode ? "sun.max" : "moon")
                    .foregroundColor(themeManager.accentColor)
                
                Text(themeManager.isDarkMode ? "Light Mode" : "Dark Mode")
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(ThemeManager.cornerRadius)
        }
    }
}

#Preview {
    ThemeToggle()
        .environmentObject(ThemeManager())
        .padding()
} 
