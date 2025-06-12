import Foundation
import UserNotifications
import os.log

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.stoicmood", category: "Notifications")
    
    @Published var isAuthorized = false
    @Published var authorizationError: String?
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func requestAuthorization() {
        logger.info("Requesting notification authorization")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.logger.error("Authorization request failed: \(error.localizedDescription)")
                    self.authorizationError = "Failed to request notification permissions: \(error.localizedDescription)"
                    self.isAuthorized = false
                    return
                }
                
                self.isAuthorized = granted
                self.authorizationError = nil
                
                if granted {
                    self.logger.info("Notification authorization granted")
                    self.scheduleDailyReminder()
                } else {
                    self.logger.notice("Notification authorization denied by user")
                    self.authorizationError = "Notifications are disabled. Please enable them in Settings."
                }
            }
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isAuthorized = settings.authorizationStatus == .authorized
                self.logger.info("Current authorization status: \(settings.authorizationStatus.rawValue)")
                
                if self.isAuthorized {
                    self.verifyScheduledNotifications()
                }
            }
        }
    }
    
    private func verifyScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            guard let self = self else { return }
            
            let hasDailyReminder = requests.contains { $0.identifier == "dailyReminder" }
            if !hasDailyReminder {
                self.logger.notice("No daily reminder found, scheduling new one")
                self.scheduleDailyReminder()
            }
        }
    }
    
    func scheduleDailyReminder() {
        guard isAuthorized else {
            logger.error("Attempted to schedule notification without authorization")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Reflection"
        content.body = "Take a moment to reflect on your day and log your mood."
        content.sound = .default
        content.categoryIdentifier = "DAILY_REMINDER"
        
        // Get reminder time from UserDefaults or use default (9:00 AM)
        let defaultTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        let reminderTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? defaultTime
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        components.second = 0 // Ensure consistent timing
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dailyReminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.logger.error("Failed to schedule notification: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.authorizationError = "Failed to schedule notification: \(error.localizedDescription)"
                }
            } else {
                self.logger.info("Successfully scheduled daily reminder for \(components.hour ?? 0):\(components.minute ?? 0)")
                DispatchQueue.main.async {
                    self.authorizationError = nil
                }
            }
        }
    }
    
    func removeDailyReminder() {
        logger.info("Removing daily reminder")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    }
    
    func updateReminderTime() {
        logger.info("Updating reminder time")
        removeDailyReminder()
        scheduleDailyReminder()
    }
}

