import SwiftUI

struct ExerciseHistoryView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var exerciseVM: ExerciseViewModel

    var body: some View {
        List {
            ForEach(exerciseVM.exerciseHistory) { entry in
                ExerciseHistoryRow(entry: entry)
            }
        }
        .navigationTitle("Exercise History")
        .navigationBarTitleDisplayMode(.inline)
        .background(themeManager.backgroundColor)
    }
}

struct ExerciseHistoryRow: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let entry: ExerciseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
            Text(entry.prompt)
                .font(.headline)
                .foregroundColor(themeManager.textColor)

            Text(entry.response)
                .font(.body)
                .foregroundColor(themeManager.secondaryTextColor)

            Text(entry.date, style: .date)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

#Preview {
    NavigationView {
        ExerciseHistoryView()
            .environmentObject(ThemeManager())
            .environmentObject(ExerciseViewModel())
    }
}
