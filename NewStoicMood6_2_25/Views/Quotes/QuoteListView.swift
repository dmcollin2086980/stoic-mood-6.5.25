import SwiftUI

struct QuoteListView: View {
    @EnvironmentObject private var quoteVM: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedQuote: StoicQuote?
    
    var body: some View {
        List {
            ForEach(quoteVM.quotes) { quote in
                QuoteCard(quote: quote)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        selectedQuote = quote
                    }
                    .swipeActions {
                        Button {
                            quoteVM.saveQuote(quote)
                        } label: {
                            Label("Save", systemImage: "bookmark")
                        }
                        .tint(themeManager.accentColor)
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
        QuoteListView()
            .environmentObject(ThemeManager())
            .environmentObject(QuoteViewModel())
    }
} 
