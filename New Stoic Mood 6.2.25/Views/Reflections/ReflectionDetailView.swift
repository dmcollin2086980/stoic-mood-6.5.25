import SwiftUI

struct ReflectionDetailView: View {
    let reflection: Reflection
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Date
                Text(reflection.date.formatted(date: .long, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)

                // Exercise Prompt
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercise Prompt:")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    Text(reflection.exercisePrompt)
                        .font(.body)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .italic()
                }

                // Reflection Content
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Reflection:")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    Text(reflection.content)
                        .font(.body)
                        .foregroundColor(themeManager.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
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
        ReflectionDetailView(
            reflection: Reflection(
                content: "Sample reflection content",
                exercisePrompt: "Sample exercise prompt"
            )
        )
        .environmentObject(ThemeManager())
    }
}
