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
                    QuoteCard(quote: quote)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            selectedQuote = quote
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.removeSavedQuote(quote)
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
                QuoteDetailView(quote: quote, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedQuotesView(viewModel: QuoteViewModel())
            .environmentObject(ThemeManager())
    }
} 