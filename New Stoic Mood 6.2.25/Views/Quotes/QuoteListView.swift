import SwiftUI

struct QuoteListView: View {
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedQuote: StoicQuote?
    
    var body: some View {
        List {
            ForEach(viewModel.quotes) { quote in
                QuoteCard(quote: quote)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        selectedQuote = quote
                    }
                    .swipeActions {
                        Button {
                            viewModel.saveQuote(quote)
                        } label: {
                            Label("Save", systemImage: "bookmark")
                        }
                        .tint(themeManager.accentColor)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .background(themeManager.backgroundColor)
        .navigationTitle("Stoic Quotes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.refreshQuotes()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(themeManager.accentColor)
                }
            }
        }
        .sheet(item: $selectedQuote) { quote in
            NavigationStack {
                QuoteDetailView(quote: quote, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuoteListView(viewModel: QuoteViewModel())
            .environmentObject(ThemeManager())
    }
} 