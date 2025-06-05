import Foundation
import SwiftUI

class ReflectionViewModel: ObservableObject {
    @Published var reflections: [Reflection] = []
    private let userDefaults = UserDefaults.standard
    private let reflectionsKey = "SavedReflections"
    
    init() {
        loadReflections()
    }
    
    var reflectionCount: Int {
        reflections.count
    }
    
    var currentStreak: Int {
        // Get unique set of days from reflections (ignore time)
        let calendar = Calendar.current
        let uniqueDays = Set(reflections.map { calendar.startOfDay(for: $0.date) })
        
        // Sort descending by date
        let sortedDays = uniqueDays.sorted(by: >)
        
        // If no reflections, streak is 0
        guard !sortedDays.isEmpty else { return 0 }
        
        // Get today's date at start of day
        let today = calendar.startOfDay(for: Date())
        
        // If no reflection today, streak is 0
        guard let firstDay = sortedDays.first,
              calendar.isDate(firstDay, inSameDayAs: today) else {
            return 0
        }
        
        // Count consecutive days
        var streak = 1
        var currentDate = today
        
        for day in sortedDays.dropFirst() {
            let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            if calendar.isDate(day, inSameDayAs: previousDate) {
                streak += 1
                currentDate = day
            } else {
                break
            }
        }
        
        return streak
    }
    
    func addReflection(content: String) {
        let reflection = Reflection(content: content)
        reflections.insert(reflection, at: 0)
        saveReflections()
    }
    
    func deleteReflection(_ reflection: Reflection) {
        reflections.removeAll { $0.id == reflection.id }
        saveReflections()
    }
    
    private func saveReflections() {
        if let encoded = try? JSONEncoder().encode(reflections) {
            userDefaults.set(encoded, forKey: reflectionsKey)
        }
    }
    
    private func loadReflections() {
        if let data = userDefaults.data(forKey: reflectionsKey),
           let decoded = try? JSONDecoder().decode([Reflection].self, from: data) {
            reflections = decoded.sorted { $0.date > $1.date }
        }
    }
} 