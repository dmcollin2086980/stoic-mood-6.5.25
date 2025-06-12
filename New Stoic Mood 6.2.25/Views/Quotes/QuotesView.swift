import SwiftUI

struct QuotesView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @State private var selectedQuote: StoicQuote?
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                List {
                    Section {
                        NavigationLink(destination: QuoteOfTheDayView()) {
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.yellow)
                                Text("Quote of the Day")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                        }
                    }
                    
                    Section("Saved Quotes") {
                        if quoteVM.savedQuotes.isEmpty {
                            Text("No saved quotes yet")
                                .foregroundColor(themeManager.secondaryTextColor)
                                .italic()
                        } else {
                            ForEach(quoteVM.savedQuotes) { quote in
                                Button(action: { selectedQuote = quote }) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(quote.text)
                                            .foregroundColor(themeManager.textColor)
                                            .lineLimit(2)
                                        Text("- \(quote.author)")
                                            .font(.caption)
                                            .foregroundColor(themeManager.secondaryTextColor)
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    quoteVM.removeSavedQuote(quoteVM.savedQuotes[index])
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .sheet(item: $selectedQuote) { quote in
                NavigationView {
                    QuoteDetailView(quote: quote)
                }
            }
        }
    }
}

#Preview {
    QuotesView()
        .environmentObject(ThemeManager())
        .environmentObject(QuoteViewModel())
} 
