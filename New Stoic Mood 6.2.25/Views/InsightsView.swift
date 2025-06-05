import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var averageMood: Double {
        guard !viewModel.entries.isEmpty else { return 0 }
        let sum = viewModel.entries.reduce(into: 0) { result, entry in
            result += entry.intensity
        }
        return sum / Double(viewModel.entries.count)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: themeManager.spacing) {
                // Mood Trends Section
                VStack(alignment: .leading, spacing: themeManager.spacing) {
                    Text("Mood Trends")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Chart(viewModel.moodFlowData) { point in
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
                .padding(themeManager.padding)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
                
                // Weekly Summary Section
                VStack(alignment: .leading, spacing: themeManager.spacing) {
                    Text("Weekly Summary")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    HStack(spacing: themeManager.spacing) {
                        StatBox(
                            title: "Average Mood",
                            value: String(format: "%.1f", averageMood),
                            themeManager: themeManager
                        )
                        
                        StatBox(
                            title: "Entries",
                            value: "\(viewModel.entries.count)",
                            themeManager: themeManager
                        )
                    }
                }
                .padding(themeManager.padding)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
                
                // Mood Distribution Section
                VStack(alignment: .leading, spacing: themeManager.spacing) {
                    Text("Mood Distribution")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    ForEach(Mood.allCases, id: \.self) { mood in
                        let count = viewModel.entries.filter { $0.mood == mood }.count
                        let percentage = viewModel.entries.isEmpty ? 0 : Double(count) / Double(viewModel.entries.count) * 100
                        
                        HStack {
                            Text(mood.emoji)
                                .font(.title2)
                            
                            Text(mood.rawValue)
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                            
                            Text("\(count) (\(Int(percentage))%)")
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .padding(themeManager.padding)
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(ThemeManager.cornerRadius)
                    }
                }
                .padding(themeManager.padding)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .shadow(color: Color.black.opacity(themeManager.shadowOpacity), radius: themeManager.shadowRadius, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle("Insights")
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
        }
        .frame(maxWidth: .infinity)
        .padding(themeManager.padding)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

#Preview {
    InsightsView()
        .environmentObject(MoodViewModel())
        .environmentObject(ThemeManager())
}
