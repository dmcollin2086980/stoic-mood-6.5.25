import SwiftUI

struct QuotesContainerView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @State private var showingAddQuote = false
    @State private var searchText = ""
    @State private var newQuoteText = ""
    @State private var newQuoteAuthor = ""
    
    private let shadowOpacity: Double = 0.1
    private let shadowRadius: CGFloat = 4
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: ThemeManager.padding) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    TextField("Search quotes...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                    }
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                
                // Quotes List
                ScrollView {
                    LazyVStack(spacing: ThemeManager.padding) {
                        ForEach(filteredQuotes) { quote in
                            QuoteCard(quote: quote)
                                .shadow(color: Color.black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Quotes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddQuote = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(themeManager.accentColor)
                }
            }
        }
        .sheet(isPresented: $showingAddQuote) {
            NavigationView {
                Form {
                    Section(header: Text("New Quote")) {
                        TextField("Quote", text: $newQuoteText)
                        TextField("Author", text: $newQuoteAuthor)
                    }
                }
                .navigationTitle("Add Quote")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingAddQuote = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if !newQuoteText.isEmpty && !newQuoteAuthor.isEmpty {
                                let newQuote = StoicQuote(
                                    text: newQuoteText,
                                    author: newQuoteAuthor
                                )
                                quoteVM.addQuote(newQuote)
                                newQuoteText = ""
                                newQuoteAuthor = ""
                                showingAddQuote = false
                            }
                        }
                        .disabled(newQuoteText.isEmpty || newQuoteAuthor.isEmpty)
                    }
                }
            }
        }
    }
    
    private var filteredQuotes: [StoicQuote] {
        if searchText.isEmpty {
            return quoteVM.quotes
        } else {
            return quoteVM.quotes.filter { quote in
                quote.text.localizedCaseInsensitiveContains(searchText) ||
                quote.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

#Preview {
    NavigationView {
        QuotesContainerView()
            .environmentObject(QuoteViewModel())
            .environmentObject(ThemeManager())
    }
} 
