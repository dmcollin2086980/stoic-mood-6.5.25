import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.secondaryTextColor)

            TextField(placeholder, text: $text)
                .foregroundColor(themeManager.textColor)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
        }
        .padding(8)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Search...")
        .environmentObject(ThemeManager())
        .padding()
}
