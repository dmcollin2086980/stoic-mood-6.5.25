import SwiftUI

struct QuoteOfTheDayView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Quote Card
            QuoteCard(quote: viewModel.dailyQuote)
                .padding(.horizontal)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)
            
            // Action Buttons
            HStack(spacing: 20) {
                ActionButton(
                    icon: "bookmark",
                    label: "Save",
                    action: { viewModel.saveQuote(viewModel.dailyQuote) }
                )
                
                ActionButton(
                    icon: "square.and.arrow.up",
                    label: "Share",
                    action: { viewModel.shareQuote(viewModel.dailyQuote) }
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(themeManager.backgroundColor)
        .sheet(isPresented: $viewModel.isShareSheetPresented) {
            ShareSheet(activityItems: [viewModel.shareText])
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
    QuoteOfTheDayView(viewModel: QuoteViewModel())
        .environmentObject(ThemeManager())
} 