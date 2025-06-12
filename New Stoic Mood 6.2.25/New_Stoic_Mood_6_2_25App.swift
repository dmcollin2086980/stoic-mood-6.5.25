//
//  New_Stoic_Mood_6_2_25App.swift
//  New Stoic Mood 6.2.25
//
//  Created by Daniel Collinsworth on 6/2/25.
//

import SwiftUI

@main
struct New_Stoic_Mood_6_2_25App: App {
    @StateObject private var moodVM = MoodViewModel()
    @StateObject private var reflectionVM = ReflectionViewModel()
    @StateObject private var exerciseVM = ExerciseViewModel()
    @StateObject private var quoteVM = QuoteViewModel()
    @StateObject private var themeManager = ThemeManager()
    @State private var showLaunchScreen = true

    init() {
        // Initialize any required setup here
    }

    private func populateExampleDataIfNeeded() {
        #if DEBUG
        if !UserDefaults.standard.bool(forKey: "ExampleDataPopulated") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ExampleDataManager.shared.populateAllExampleData(
                    moodVM: moodVM,
                    reflectionVM: reflectionVM,
                    exerciseVM: exerciseVM,
                    quoteVM: quoteVM
                ) {
                    print("Initial example data population completed")
                }
            }
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                } else {
                    TabView {
                        NavigationStack {
                            DashboardView()
                        }
                        .tabItem {
                            Label("Dashboard", systemImage: "chart.bar.fill")
                        }
                        NavigationStack {
                            JournalView()
                        }
                        .tabItem {
                            Label("Journal", systemImage: "book.fill")
                        }
                        NavigationStack {
                            QuotesContainerView()
                        }
                        .tabItem {
                            Label("Quotes", systemImage: "quote.bubble.fill")
                        }
                        NavigationStack {
                            DailyExerciseView()
                        }
                        .tabItem {
                            Label("Exercises", systemImage: "book.closed")
                        }
                        NavigationStack {
                            SettingsView()
                        }
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    .tint(themeManager.accentColor)
                    .environmentObject(moodVM)
                    .environmentObject(themeManager)
                    .environmentObject(reflectionVM)
                    .environmentObject(exerciseVM)
                    .environmentObject(quoteVM)
                    .onAppear {
                        populateExampleDataIfNeeded()
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showLaunchScreen = false
                    }
                }
            }
        }
    }
}
