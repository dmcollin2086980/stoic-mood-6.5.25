import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Mood Distribution Section
                VStack(alignment: .leading, spacing: themeManager.spacing) {
                    Text("Mood Distribution")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    ForEach(Mood.allCases, id: \.self) { mood in
                        let count = viewModel.moodEntries.filter { $0.mood == mood }.count
                        let percentage = viewModel.moodEntries.isEmpty ? 0 : Double(count) / Double(viewModel.moodEntries.count) * 100
                        
                        HStack {
                            Text(mood.emoji)
                                .font(.title2)
                            
                            Text(mood.name)
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
                
                // Text Analysis Section
                if let analysis = viewModel.textAnalysis {
                    VStack(alignment: .leading, spacing: themeManager.spacing) {
                        Text("Journal Analysis")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            StatRow(title: "Average Length", value: "\(analysis.averageLength) words")
                            StatRow(title: "Writing Style", value: analysis.writingStyle)
                            StatRow(title: "Sentiment", value: formatSentiment(analysis.sentiment))
                            StatRow(title: "Common Themes", value: analysis.themes.joined(separator: ", "))
                        }
                    }
                    .padding(themeManager.padding)
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                }
                
                // Mood Transitions Section
                if let transitions = viewModel.moodTransitions {
                    VStack(alignment: .leading, spacing: themeManager.spacing) {
                        Text("Mood Transitions")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        ForEach(transitions) { transition in
                            HStack {
                                Text("\(transition.from.emoji) → \(transition.to.emoji)")
                                    .font(.title2)
                                Spacer()
                                Text("\(transition.count) times")
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
                }
                
                // Time Patterns Section
                if !viewModel.timePatterns.isEmpty {
                    VStack(alignment: .leading, spacing: themeManager.spacing) {
                        Text("Time Patterns")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        ForEach(viewModel.timePatterns) { pattern in
                            HStack {
                                Image(systemName: pattern.icon)
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text(pattern.title)
                                        .foregroundColor(themeManager.textColor)
                                    Text(pattern.description)
                                        .font(.caption)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                                Spacer()
                            }
                            .padding(themeManager.padding)
                            .background(themeManager.cardBackgroundColor)
                            .cornerRadius(ThemeManager.cornerRadius)
                        }
                    }
                    .padding(themeManager.padding)
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                }
            }
            .padding()
        }
        .navigationTitle("Insights")
    }
    
    private func formatSentiment(_ score: Double) -> String {
        switch score {
        case 0.7...:
            return "Very Positive"
        case 0.5..<0.7:
            return "Moderately Positive"
        case 0.3..<0.5:
            return "Neutral"
        case 0.1..<0.3:
            return "Moderately Negative"
        default:
            return "Very Negative"
        }
    }
}

#Preview {
    InsightsView()
        .environmentObject(MoodViewModel())
        .environmentObject(ThemeManager())
}
