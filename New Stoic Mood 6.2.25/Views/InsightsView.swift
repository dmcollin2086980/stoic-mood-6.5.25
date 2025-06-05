import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var moodVM: MoodViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: ThemeManager.padding) {
                // Mood Trends
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Mood Trends")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Text("Your mood has been trending \(moodVM.moodTrend) over the past week.")
                        .font(.body)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                
                // Common Triggers
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Common Triggers")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    ForEach(moodVM.commonTriggers, id: \.self) { trigger in
                        Text("• \(trigger)")
                            .font(.body)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                
                // Journal Insights
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Journal Insights")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    ForEach(moodVM.journalInsights, id: \.self) { insight in
                        Text("• \(insight)")
                            .font(.body)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                
                // Exercise Impact
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Exercise Impact")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Text("Regular exercise has been associated with \(moodVM.exerciseImpact) in your mood.")
                        .font(.body)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
            }
            .padding()
        }
        .background(themeManager.backgroundColor)
        .navigationTitle("Insights")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        InsightsView()
            .environmentObject(ThemeManager())
            .environmentObject(MoodViewModel())
    }
}
