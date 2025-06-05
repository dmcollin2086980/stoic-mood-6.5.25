import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Daily Quote at the top
                QuoteView(themeManager: themeManager)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                
                // Mood Flow Chart
                DashboardMoodFlowChartView(data: viewModel.moodFlowData)
                    .padding(.horizontal)
                
                // Week Overview
                WeekOverviewView(entries: viewModel.entries, themeManager: themeManager)
                    .padding(.horizontal)
                
                // Streak Summary Section
                HStack(spacing: 8) {
                    StatCard(
                        title: "Current Streak",
                        value: "\(viewModel.currentStreak)",
                        subtitle: "days",
                        themeManager: themeManager
                    )
                    
                    StatCard(
                        title: "Total Entries",
                        value: "\(viewModel.entries.count)",
                        subtitle: "entries",
                        themeManager: themeManager
                    )
                    
                    StatCard(
                        title: "Reflection Streak",
                        value: "\(reflectionVM.currentStreak)",
                        subtitle: "days",
                        themeManager: themeManager
                    )
                    
                    StatCard(
                        title: "Reflections",
                        value: "\(reflectionVM.reflectionCount)",
                        subtitle: "total",
                        themeManager: themeManager
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .navigationTitle("Dashboard")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
                .minimumScaleFactor(0.8)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(themeManager.secondaryTextColor)
                .minimumScaleFactor(0.8)
        }
        .frame(width: UIScreen.main.bounds.width * 0.22, height: 90)
        .padding(.vertical, 8)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
        .environmentObject(MoodViewModel())
        .environmentObject(ReflectionViewModel())
        .environmentObject(ThemeManager())
} 