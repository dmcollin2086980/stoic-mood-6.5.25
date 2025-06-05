import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject private var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var quoteVM = QuoteViewModel()
    
    private var weeklyEntries: [MoodEntry] {
        let calendar = Calendar.current
        let today = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
        
        return viewModel.moodEntries.filter { entry in
            entry.timestamp >= weekAgo && entry.timestamp <= today
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Stoic Wisdom
                    DailyQuoteView(quote: quoteVM.dailyQuote, viewModel: quoteVM)
                        .padding(.horizontal)
                    
                    // Mood Flow Chart
                    VStack(alignment: .leading, spacing: themeManager.spacing) {
                        Text("Mood Flow")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        Chart {
                            ForEach(viewModel.moodFlowData) { dataPoint in
                                LineMark(
                                    x: .value("Date", dataPoint.date),
                                    y: .value("Mood", dataPoint.value)
                                )
                                .foregroundStyle(themeManager.accentColor)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                
                                PointMark(
                                    x: .value("Date", dataPoint.date),
                                    y: .value("Mood", dataPoint.value)
                                )
                                .foregroundStyle(themeManager.accentColor)
                            }
                        }
                        .frame(height: 200)
                        .chartYScale(domain: 1...5)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.weekday(.narrow))
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        Text("\(intValue)")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                    
                    // This Week's Journey
                    VStack(alignment: .leading, spacing: themeManager.spacing) {
                        Text("This Week's Journey")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        HStack(spacing: 12) {
                            ForEach(0..<7) { dayOffset in
                                let date = Calendar.current.date(byAdding: .day, value: -6 + dayOffset, to: Date())!
                                let entry = weeklyEntries.first { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
                                
                                VStack(spacing: 8) {
                                    Text(entry?.mood.emoji ?? "📝")
                                        .font(.title2)
                                    Text(date.formatted(.dateTime.weekday(.narrow)))
                                        .font(.caption)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                    
                    // Statistics Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        // Top Row
                        StatCard(
                            title: "Current Streak",
                            value: "\(viewModel.calculateCurrentStreak())",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Total Entries",
                            value: "\(viewModel.moodEntries.count)",
                            icon: "book.fill",
                            color: .blue
                        )
                        
                        // Bottom Row
                        StatCard(
                            title: "Reflection Streak",
                            value: "\(viewModel.calculateReflectionStreak())",
                            icon: "pencil.and.scribble",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Reflections",
                            value: "\(viewModel.moodEntries.filter { $0.journalEntry != nil }.count)",
                            icon: "text.book.closed.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .background(themeManager.backgroundColor)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor)
            }
            
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(themeManager.textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

#Preview {
    DashboardView()
        .environmentObject(MoodViewModel())
        .environmentObject(ThemeManager())
} 