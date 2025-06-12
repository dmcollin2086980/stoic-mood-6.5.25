import SwiftUI

struct QuoteCard: View {
    let quote: StoicQuote
    @EnvironmentObject private var themeManager: ThemeManager

    private let shadowOpacity: Double = 0.1
    private let shadowRadius: CGFloat = 4

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeManager.padding) {
            Text(quote.text)
                .font(.body)
                .italic()
                .foregroundColor(themeManager.textColor)
                .multilineTextAlignment(.leading)

            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                .stroke(themeManager.borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    QuoteCard(
        quote: StoicQuote(
            text: "The happiness of your life depends upon the quality of your thoughts.",
            author: "Marcus Aurelius"
        )
    )
    .environmentObject(ThemeManager())
    .padding()
}
