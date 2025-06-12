import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var moodVM: MoodViewModel
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
                MoodSelectionView { moodType, intensity in
                    let mood = moodType.toMood
                    let clampedIntensity = max(1, min(5, intensity))
                    let newEntry = MoodEntry(mood: mood, intensity: clampedIntensity, timestamp: Date(), journalEntry: nil)
                    moodVM.moodEntries.insert(newEntry, at: 0)
                    moodVM.saveMoodEntries()
                    // Optionally: show a success message or navigate
                }
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
