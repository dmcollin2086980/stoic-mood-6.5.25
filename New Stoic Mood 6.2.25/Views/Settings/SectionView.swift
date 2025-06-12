import SwiftUI

struct SectionView: View {
    let title: String
    let content: String
    let themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.textColor)

            Text(content)
                .font(.body)
                .foregroundColor(themeManager.secondaryTextColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SectionView(
        title: "Example Section",
        content: "This is an example section with some content that demonstrates the styling and layout.",
        themeManager: ThemeManager()
    )
    .padding()
}
