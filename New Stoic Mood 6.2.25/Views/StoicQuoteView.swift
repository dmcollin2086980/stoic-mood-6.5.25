import SwiftUI

struct StoicQuoteView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentQuote: String = ""
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            Text(currentQuote)
                .font(.system(size: 24, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.textColor)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isAnimating)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
        }
        .padding()
        .onAppear {
            currentQuote = StoicQuotesManager.shared.getRandomQuote()
            isAnimating = true
        }
    }
}

#Preview {
    StoicQuoteView()
        .environmentObject(ThemeManager())
}
