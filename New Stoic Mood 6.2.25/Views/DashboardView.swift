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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week's Journey")
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
            HStack(spacing: 10) {
                ForEach(0..<7) { day in
                    let date = Calendar.current.date(byAdding: .day, value: -6 + day, to: Date())!
                    let dayEntries = entries.filter {
                        Calendar.current.isDate($0.date, inSameDayAs: date)
                    }
                    
                    VStack(spacing: 8) {
                        Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        if let firstEntry = dayEntries.first {
                            Text(firstEntry.mood.emoji)
                                .font(.title2)
                        } else {
                            Circle()
                                .fill(themeManager.cardBackgroundColor)
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(date.formatted(.dateTime.weekday(.wide))): \(dayEntries.first?.mood.emoji ?? "No entry")")
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