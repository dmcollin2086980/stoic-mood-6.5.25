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
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
