import SwiftUI

/// A view that allows users to select their mood and intensity level.
/// This view provides a grid of mood options and a slider for intensity selection.
struct EnhancedMoodSelectionView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var selectedMood: Mood?
    @Binding var selectedIntensity: Double
    var onSelect: (Mood, Double, String?) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingEmojiPicker = false
    @State private var note: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: ThemeManager.padding) {
                    // Mood Display
                    Text(selectedMood?.emoji ?? "")
                        .font(.system(size: 60))
                        .padding()

                    // Intensity Slider
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        Text("Intensity")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)

                        Slider(value: $selectedIntensity, in: 1.0...10.0, step: 1.0)
                            .accentColor(themeManager.accentColor)

                        Text("\(Int(selectedIntensity))")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)

                    // Note Input
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        Text("Note (Optional)")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)

                        TextEditor(text: $note)
                            .frame(height: 100)
                            .padding(ThemeManager.smallPadding)
                            .background(themeManager.backgroundColor)
                            .cornerRadius(ThemeManager.cornerRadius)
                    }
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)

                    // Save Button
                    Button {
                        if let mood = selectedMood {
                            onSelect(mood, selectedIntensity, note.isEmpty ? nil : note)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.accentColor)
                            .cornerRadius(ThemeManager.cornerRadius)
                    }
                    .disabled(selectedMood == nil)
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Record Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
            }
        }
    }
}

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    private let emojis = ["😊", "😌", "😐", "😔", "😢", "😡", "😴", "🤔", "😎", "🥰"]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: ThemeManager.spacing) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button {
                            selectedEmoji = emoji
                            dismiss()
                        } label: {
                            Text(emoji)
                                .font(.system(size: 32))
                                .frame(maxWidth: .infinity)
                                .padding(ThemeManager.padding)
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(ThemeManager.cornerRadius)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Emoji")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
            }
        }
    }
}

#Preview {
    EnhancedMoodSelectionView(
        selectedMood: .constant(.happy),
        selectedIntensity: .constant(5),
        onSelect: { _, _, _ in }
    )
    .environmentObject(ThemeManager())
}
