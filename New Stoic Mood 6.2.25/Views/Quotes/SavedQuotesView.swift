import SwiftUI

struct SavedQuotesView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedQuote: StoicQuote?
    
    var body: some View {
        List {
            if viewModel.savedQuotes.isEmpty {
                Text("No saved quotes yet")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .italic()
            } else {
                ForEach(viewModel.savedQuotes) { quote in
                    Button(action: { selectedQuote = quote }) {
                        Text(quote.text)
                            .foregroundColor(themeManager.textColor)
                            .lineLimit(2)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.removeSavedQuote(viewModel.savedQuotes[index])
                    }
                }
            }
        }
        .navigationTitle("Saved Quotes")
        .sheet(item: $selectedQuote) { quote in
            NavigationView {
                QuoteDetailView(quote: quote, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    NavigationView {
        SavedQuotesView(viewModel: QuoteViewModel())
            .environmentObject(ThemeManager())
    }
} 