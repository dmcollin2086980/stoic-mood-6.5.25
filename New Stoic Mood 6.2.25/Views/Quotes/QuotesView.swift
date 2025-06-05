import SwiftUI

struct QuotesView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedQuote: StoicQuote?
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                List {
                    Section {
                        NavigationLink(destination: QuoteOfTheDayView(viewModel: viewModel)) {
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
                        if viewModel.savedQuotes.isEmpty {
                            Text("No saved quotes yet")
                                .foregroundColor(themeManager.secondaryTextColor)
                                .italic()
                        } else {
                            ForEach(viewModel.savedQuotes) { quote in
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
                                    viewModel.removeSavedQuote(viewModel.savedQuotes[index])
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Quotes")
            .sheet(item: $selectedQuote) { quote in
                NavigationView {
                    QuoteDetailView(quote: quote, viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    QuotesView(viewModel: QuoteViewModel())
        .environmentObject(ThemeManager())
} 