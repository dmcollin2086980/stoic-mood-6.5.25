import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Dashboard")
                }
                .tag(0)
            
            JournalView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Journal")
                }
                .tag(1)
            
            QuotesView()
                .tabItem {
                    Image(systemName: "text.quote")
                    Text("Quotes")
                }
                .tag(2)
            
            DailyExerciseView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Exercises")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .tint(themeManager.accentColor)
        .onChange(of: selectedTab) { _ in
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
