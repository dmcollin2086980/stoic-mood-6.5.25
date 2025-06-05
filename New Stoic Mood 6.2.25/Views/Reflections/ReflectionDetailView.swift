import SwiftUI

struct ReflectionDetailView: View {
    let reflection: Reflection
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(reflection.date.formatted(date: .long, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text(reflection.content)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .background(themeManager.backgroundColor)
        .navigationTitle("Reflection")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ReflectionDetailView(reflection: Reflection(content: "Sample reflection content"))
            .environmentObject(ThemeManager())
    }
} 