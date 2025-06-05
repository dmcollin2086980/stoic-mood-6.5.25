//
//  New_Stoic_Mood_6_2_25App.swift
//  New Stoic Mood 6.2.25
//
//  Created by Daniel Collinsworth on 6/2/25.
//

import SwiftUI

@main
struct New_Stoic_Mood_6_2_25App: App {
    @StateObject private var viewModel = MoodViewModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var reflectionVM = ReflectionViewModel()
    @StateObject private var quoteVM = QuoteViewModel()
    
    var body: some Scene {
        WindowGroup {
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
            .environmentObject(viewModel)
            .environmentObject(themeManager)
            .environmentObject(reflectionVM)
            .environmentObject(quoteVM)
        }
    }
}
