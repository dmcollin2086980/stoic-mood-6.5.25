import SwiftUI

struct SavedQuotesView: View {
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedQuote: StoicQuote?

    var body: some View {
        List {
            if quoteVM.savedQuotes.isEmpty {
                Text("No saved quotes yet")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .italic()
            } else {
                ForEach(quoteVM.savedQuotes) { quote in
                    QuoteCard(quote: quote)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            selectedQuote = quote
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                quoteVM.removeSavedQuote(quote)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(themeManager.backgroundColor)
        .sheet(item: $selectedQuote) { quote in
            NavigationStack {
                QuoteDetailView(quote: quote)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedQuotesView()
            .environmentObject(ThemeManager())
            .environmentObject(QuoteViewModel())
    }
}
