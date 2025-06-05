import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            .tag(0)
            
            NavigationView {
                MoodSelectionView()
            }
            .tabItem {
                Label("Mood", systemImage: "face.smiling")
            }
            .tag(1)
            
            NavigationView {
                DailyExerciseView()
            }
            .tabItem {
                Label("Exercise", systemImage: "figure.walk")
            }
            .tag(2)
            
            NavigationView {
                JournalView()
            }
            .tabItem {
                Label("Journal", systemImage: "book")
            }
            .tag(3)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(4)
        }
        .accentColor(themeManager.accentColor)
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
        .environmentObject(MoodViewModel())
        .environmentObject(ExerciseViewModel())
        .environmentObject(QuoteViewModel())
} 