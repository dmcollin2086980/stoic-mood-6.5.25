import SwiftUI

enum Tab {
    case dashboard
    case journal
    case quotes
    case exercise
    case settings
}

struct MainView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab: Tab = .dashboard
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(Tab.dashboard)
            
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }
                .tag(Tab.journal)
            
            QuotesView(viewModel: QuoteViewModel())
                .tabItem {
                    Label("Quotes", systemImage: "quote.bubble.fill")
                }
                .tag(Tab.quotes)
            
            DailyExerciseView()
                .tabItem {
                    Label("Exercise", systemImage: "figure.walk")
                }
                .tag(Tab.exercise)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(themeManager.accentColor)
        .onChange(of: selectedTab) { oldValue, newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                // This creates a subtle bounce effect when switching tabs
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(MoodViewModel())
        .environmentObject(ThemeManager())
} 
