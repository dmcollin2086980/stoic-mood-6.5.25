import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: themeManager.spacing) {
                // Daily Quote at the top
                QuoteView(themeManager: themeManager)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, themeManager.padding)
                
                // Mood Flow Chart
                DashboardMoodFlowChartView(data: viewModel.moodFlowData)
                    .padding(.horizontal)
                
                // Week Overview
                WeekOverviewView(entries: viewModel.entries, themeManager: themeManager)
                    .padding(.horizontal)
                
                // Streak Summary Section
                HStack(spacing: 4) {
                    ForEach([
                        ("Current Streak", "\(viewModel.currentStreak)", "days"),
                        ("Total Entries", "\(viewModel.entries.count)", "entries"),
                        ("Reflection Streak", "\(reflectionVM.currentStreak)", "days"),
                        ("Reflections", "\(reflectionVM.reflectionCount)", "total")
                    ], id: \.0) { metric in
                        MetricCard(
                            title: metric.0,
                            value: metric.1,
                            subtitle: metric.2,
                            themeManager: themeManager
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            }
            .padding(.top, themeManager.padding)
            .padding(.bottom, 32)
            .overlay {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: themeManager.accentColor))
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
        .onAppear {
            debugPrintDashboardData()
        }
    }
    
    private func debugPrintDashboardData() {
        #if DEBUG
        print("=== Dashboard Data Debug ===")
        print("Total Mood Entries: \(viewModel.entries.count)")
        print("Mood Flow Data Points: \(viewModel.moodFlowData.count)")
        
        if let firstEntry = viewModel.entries.first, let lastEntry = viewModel.entries.last {
            print("Date Range: \(firstEntry.date.formatted()) to \(lastEntry.date.formatted())")
        }
        
        // Print current week's entries
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.date(byAdding: .day, value: -6, to: today)!
        let weekEntries = viewModel.entries.filter { entry in
            entry.date >= weekStart && entry.date <= today
        }
        print("Current Week Entries: \(weekEntries.count)")
        
        // Print streak information
        print("Current Streak: \(viewModel.currentStreak)")
        print("Reflection Streak: \(reflectionVM.currentStreak)")
        print("Total Reflections: \(reflectionVM.reflectionCount)")
        print("=========================")
        #endif
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(themeManager.secondaryTextColor)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
                .minimumScaleFactor(0.8)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(themeManager.secondaryTextColor)
                .minimumScaleFactor(0.8)
        }
        .frame(width: UIScreen.main.bounds.width / 4 - 16, height: 80)
        .padding(.vertical, 8)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value) \(subtitle)")
    }
}

struct QuoteView: View {
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Daily Stoic Wisdom")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Text(StoicQuotesManager.shared.getRandomQuote())
                .font(.title3)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.textColor)
                .lineLimit(3)
                .padding(.horizontal)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Daily Stoic Wisdom: \(StoicQuotesManager.shared.getRandomQuote())")
    }
}

struct DashboardMoodFlowChartView: View {
    let data: [MoodFlowData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Flow")
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
            if data.isEmpty {
                Text("No mood data available")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                Chart(data) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Mood", point.value)
                    )
                    .foregroundStyle(themeManager.accentColor)
                    
                    PointMark(
                        x: .value("Date", point.date),
                        y: .value("Mood", point.value)
                    )
                    .foregroundStyle(themeManager.accentColor)
                }
                .frame(height: 200)
                .chartYScale(domain: 0...10)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mood Flow Chart showing mood trends over time")
    }
}

struct WeekOverviewView: View {
    let entries: [JournalEntry]
    let themeManager: ThemeManager
    
    private func getAverageMood(for date: Date) -> String {
        let dayEntries = entries.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        
        if dayEntries.isEmpty {
            return "😶" // Fallback emoji for no entries
        }
        
        // Calculate average intensity
        let totalIntensity = dayEntries.reduce(0) { $0 + $1.intensity }
        let averageIntensity = Double(totalIntensity) / Double(dayEntries.count)
        
        // Map intensity to emoji
        switch averageIntensity {
        case 0...3: return "😔"
        case 3...5: return "😐"
        case 5...7: return "🙂"
        default: return "😊"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week's Journey")
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
            HStack(spacing: 10) {
                ForEach(0..<7) { day in
                    let date = Calendar.current.date(byAdding: .day, value: -6 + day, to: Date())!
                    let moodEmoji = getAverageMood(for: date)
                    
                    VStack(spacing: 8) {
                        Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        Text(moodEmoji)
                            .font(.title2)
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(date.formatted(.dateTime.weekday(.wide))): \(moodEmoji)")
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
        .environmentObject(MoodViewModel())
        .environmentObject(ReflectionViewModel())
        .environmentObject(ThemeManager())
} 