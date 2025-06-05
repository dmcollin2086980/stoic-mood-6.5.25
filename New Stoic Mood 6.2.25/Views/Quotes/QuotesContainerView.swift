import SwiftUI

struct QuotesContainerView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Daily Quote Section
            DailyQuoteView(quote: viewModel.dailyQuote, viewModel: viewModel)
                .padding(.horizontal)
                .padding(.top)
            
            // Tab Selection
            Picker("Quote Section", selection: $selectedTab) {
                Text("All Quotes").tag(0)
                Text("Saved").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content based on selected tab
            TabView(selection: $selectedTab) {
                // All Quotes Tab
                QuoteListView(viewModel: viewModel)
                    .tag(0)
                
                // Saved Quotes Tab
                SavedQuotesView(viewModel: viewModel)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(themeManager.backgroundColor)
    }
}

struct DailyQuoteView: View {
    let quote: StoicQuote
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(spacing: themeManager.spacing) {
            Text("Daily Stoic Wisdom")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Text(quote.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.textColor)
                .padding(.horizontal)
            
            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
            
            HStack(spacing: themeManager.spacing) {
                Button(action: {
                    viewModel.saveQuote(quote)
                }) {
                    Label("Save", systemImage: "bookmark")
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    showingShareSheet = true
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: ["\(quote.text) - \(quote.author)"])
        }
    }
}

#Preview {
    NavigationStack {
        QuotesContainerView()
            .environmentObject(ThemeManager())
    }
} 