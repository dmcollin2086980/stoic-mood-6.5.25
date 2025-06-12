import SwiftUI
import Charts

struct MoodStatsView: View {
    @EnvironmentObject private var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Mood Distribution Chart
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mood Distribution")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    let stats = viewModel.getMoodStats()
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Positive")
                                .foregroundColor(.green)
                            Text("\(Int(stats.positivePercentage))%")
                                .font(.title2)
                                .bold()
                        }

                        VStack(alignment: .leading) {
                            Text("Neutral")
                                .foregroundColor(.blue)
                            Text("\(Int(stats.neutralPercentage))%")
                                .font(.title2)
                                .bold()
                        }

                        VStack(alignment: .leading) {
                            Text("Negative")
                                .foregroundColor(.red)
                            Text("\(Int(stats.negativePercentage))%")
                                .font(.title2)
                                .bold()
                        }
                    }
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                }

                // Average Intensity
                VStack(alignment: .leading, spacing: 10) {
                    Text("Average Intensity")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    let stats = viewModel.getMoodStats()
                    HStack {
                        Text(String(repeating: "⭐️", count: Int(round(stats.averageIntensity))))
                            .font(.title)

                        Text(String(format: "%.1f", stats.averageIntensity))
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                }

                // Most Common Mood
                if let mostCommon = viewModel.getMoodStats().mostCommonMood {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Most Common Mood")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)

                        HStack {
                            Text(mostCommon.emoji)
                                .font(.title)

                            Text(mostCommon.name)
                                .font(.title2)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(ThemeManager.cornerRadius)
                    }
                }

                // Recent Entries
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Entries")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    ForEach(viewModel.moodEntries.prefix(5)) { entry in
                        HStack {
                            Text(entry.mood.emoji)
                                .font(.title2)

                            VStack(alignment: .leading) {
                                Text(entry.mood.name)
                                    .font(.headline)

                                if let journal = entry.journalEntry {
                                    Text(journal)
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.textColor.opacity(0.8))
                                        .lineLimit(2)
                                }

                                Text(entry.formattedDate)
                                    .font(.caption)
                                    .foregroundColor(themeManager.textColor.opacity(0.6))
                            }

                            Spacer()

                            Text(entry.formattedIntensity)
                                .font(.caption)
                        }
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(ThemeManager.cornerRadius)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Mood Statistics")
        .background(themeManager.backgroundColor)
    }
}

#Preview {
    NavigationView {
        MoodStatsView()
            .environmentObject(MoodViewModel())
            .environmentObject(ThemeManager())
    }
}
