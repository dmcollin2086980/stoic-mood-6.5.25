import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingThemeSelection = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("dailyReminderTime") private var dailyReminderTime = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                List {
                    // Theme Section
                    Section {
                        Button {
                            showingThemeSelection = true
                        } label: {
                            HStack {
                                Text("Theme")
                                Spacer()
                                Text(themeManager.currentTheme.rawValue)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                        }
                        .foregroundColor(themeManager.textColor)
                    } header: {
                        Text("Appearance")
                    }
                    
                    // Notifications Section
                    Section {
                        Toggle("Daily Reminders", isOn: $notificationsEnabled)
                            .tint(themeManager.accentColor)
                        
                        if notificationsEnabled {
                            DatePicker(
                                "Reminder Time",
                                selection: $dailyReminderTime,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    } header: {
                        Text("Notifications")
                    }
                    
                    // About Section
                    Section {
                        Link(destination: URL(string: "https://www.stoicmood.app/privacy")!) {
                            HStack {
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                        }
                        
                        Link(destination: URL(string: "https://www.stoicmood.app/terms")!) {
                            HStack {
                                Text("Terms of Service")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                        }
                        
                        HStack {
                            Text("Version")
                            Spacer()
                            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                    } header: {
                        Text("About")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingThemeSelection) {
                ThemeSelectionView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
} 