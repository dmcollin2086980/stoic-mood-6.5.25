import SwiftUI

struct QuoteOfTheDayView: View {
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Quote Card
            QuoteCard(quote: quoteVM.dailyQuote)
                .padding(.horizontal)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)
            
            // Action Buttons
            HStack(spacing: 20) {
                ActionButton(
                    icon: "bookmark",
                    label: "Save",
                    action: { quoteVM.saveQuote(quoteVM.dailyQuote) }
                )
                
                ActionButton(
                    icon: "square.and.arrow.up",
                    label: "Share",
                    action: { quoteVM.shareQuote(quoteVM.dailyQuote) }
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(themeManager.backgroundColor)
        .sheet(isPresented: $quoteVM.isShareSheetPresented) {
            ShareSheet(activityItems: [quoteVM.shareText])
        }
    }
}

private struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(themeManager.accentColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
        }
    }
}

#Preview {
    QuoteOfTheDayView()
        .environmentObject(ThemeManager())
        .environmentObject(QuoteViewModel())
} 
