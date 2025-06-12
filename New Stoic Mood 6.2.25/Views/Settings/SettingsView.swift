import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var moodVM: MoodViewModel
    @EnvironmentObject private var exerciseVM: ExerciseViewModel
    @EnvironmentObject private var quoteVM: QuoteViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Appearance")) {
                    ThemeToggle()
                }
                
                Section(header: Text("Data Management")) {
                    Button(role: .destructive) {
                        moodVM.clearAllData()
                    } label: {
                        Label("Clear Mood History", systemImage: "trash")
                    }
                    
                    Button(role: .destructive) {
                        exerciseVM.clearAllData()
                    } label: {
                        Label("Clear Exercise History", systemImage: "trash")
                    }
                    
                    Button(role: .destructive) {
                        quoteVM.clearAllData()
                    } label: {
                        Label("Clear Saved Quotes", systemImage: "trash")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(MoodViewModel())
        .environmentObject(ExerciseViewModel())
        .environmentObject(QuoteViewModel())
} 
