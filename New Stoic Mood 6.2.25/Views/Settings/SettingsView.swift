import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var notificationManager = NotificationManager.shared
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("reminderTime") private var reminderTime = Date()
    @State private var showingPermissionAlert = false
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            List {
                Section {
                    Toggle("Daily Reminders", isOn: $notificationsEnabled)
                        .tint(themeManager.accentColor)
                        .onChange(of: notificationsEnabled) { oldValue, newValue in
                            if newValue {
                                notificationManager.requestAuthorization()
                            } else {
                                notificationManager.removeDailyReminder()
                            }
                        }
                    
                    if notificationsEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: reminderTime) { oldValue, newValue in
                            notificationManager.updateReminderTime()
                        }
                    }
                } header: {
                    Text("Notifications")
                }
                
                Section {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("Terms of Service")
                    }
                } header: {
                    Text("Legal")
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    Link(destination: URL(string: "https://stoicmood.app/support")!) {
                        Text("Contact Support")
                    }
                } header: {
                    Text("About")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .alert("Notification Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings", role: .none) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable notifications in Settings to receive daily reminders.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(ThemeManager())
    }
} 