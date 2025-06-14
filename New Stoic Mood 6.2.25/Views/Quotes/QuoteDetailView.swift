import SwiftUI

struct QuoteDetailView: View {
    let quote: StoicQuote
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Quote Card
                QuoteCard(quote: quote)
                    .padding(.horizontal)
                
                // Actions
                HStack(spacing: 20) {
                    ActionButton(
                        icon: "bookmark",
                        label: "Save",
                        action: { quoteVM.saveQuote(quote) }
                    )
                    
                    ActionButton(
                        icon: "square.and.arrow.up",
                        label: "Share",
                        action: { quoteVM.shareQuote(quote) }
                    )
                    
                    ActionButton(
                        icon: "text.quote",
                        label: "Copy",
                        action: { quoteVM.copyQuote(quote) }
                    )
                }
                .padding()
                
                // Author Info
                VStack(alignment: .leading, spacing: 10) {
                    Text("About \(quote.author)")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Text("Marcus Aurelius was a Roman emperor and Stoic philosopher who wrote 'Meditations', a series of personal writings on Stoic philosophy.")
                        .font(.body)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(themeManager.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
        }
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

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        QuoteDetailView(
            quote: StoicQuote(
                text: "The happiness of your life depends upon the quality of your thoughts.",
                author: "Marcus Aurelius"
            )
        )
        .environmentObject(ThemeManager())
        .environmentObject(QuoteViewModel())
    }
}

