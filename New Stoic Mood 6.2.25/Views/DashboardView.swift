import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var moodVM: MoodViewModel
    @EnvironmentObject private var quoteVM: QuoteViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: ThemeManager.padding) {
                // Daily Quote
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Daily Quote")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    if let quote = quoteVM.dailyQuote {
                        Text(quote.text)
                            .font(.body)
                            .italic()
                            .foregroundColor(themeManager.textColor)

                        Text("- \(quote.author)")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)

                // Mood Flow
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Mood Flow")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: ThemeManager.padding) {
                            ForEach(moodVM.recentMoods) { entry in
                                VStack {
                                    Text(entry.emoji)
                                        .font(.title)
                                    Text(entry.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)

                // Statistics
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: ThemeManager.padding) {
                    StatCard(
                        title: "Mood Streak",
                        value: "\(moodVM.currentStreak)",
                        icon: "flame"
                    )

                    StatCard(
                        title: "Journal Entries",
                        value: "\(moodVM.journalEntryCount)",
                        icon: "book"
                    )

                    StatCard(
                        title: "Exercises",
                        value: "\(moodVM.exerciseCount)",
                        icon: "figure.walk"
                    )

                    StatCard(
                        title: "Quotes",
                        value: "\(quoteVM.quoteCount)",
                        icon: "quote.bubble"
                    )
                }

                // Recent Activity
                VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                    Text("Recent Activity")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)

                    ForEach(moodVM.recentActivity) { activity in
                        HStack {
                            Image(systemName: activity.icon)
                                .foregroundColor(themeManager.accentColor)
                            Text(activity.description)
                                .foregroundColor(themeManager.textColor)
                            Spacer()
                            Text(activity.date, style: .date)
                                .font(.caption)
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(ThemeManager.cornerRadius)
                    }
                }
            }
            .padding()
        }
        .background(themeManager.backgroundColor)
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: ThemeManager.smallPadding) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(themeManager.accentColor)

            Text(value)
                .font(.title)
                .foregroundColor(themeManager.textColor)

            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

#Preview {
    NavigationView {
        DashboardView()
            .environmentObject(ThemeManager())
            .environmentObject(MoodViewModel())
            .environmentObject(QuoteViewModel())
    }
}
