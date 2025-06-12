import SwiftUI

struct MoodHistoryView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var moodVM: MoodViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: ThemeManager.padding) {
                ForEach(moodVM.moodHistory) { entry in
                    MoodHistoryCard(entry: entry)
                }
            }
            .padding()
        }
        .background(themeManager.backgroundColor)
        .navigationTitle("Mood History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MoodHistoryCard: View {
    let entry: MoodEntry
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
            HStack {
                Text(entry.emoji)
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text(entry.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                    
                    if let note = entry.note {
                        Text(note)
                            .font(.body)
                            .foregroundColor(themeManager.textColor)
                    }
                }
                
                Spacer()
                
                Text("Intensity: \(entry.intensity)")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

#Preview {
    NavigationView {
        MoodHistoryView()
            .environmentObject(ThemeManager())
            .environmentObject(MoodViewModel())
    }
} 