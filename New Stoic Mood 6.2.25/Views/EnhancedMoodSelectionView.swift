import SwiftUI

/// A view that allows users to select their mood and intensity level.
/// This view provides a grid of mood options and a slider for intensity selection.
struct EnhancedMoodSelectionView: View {
    @Binding var selectedMood: Mood?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedIntensity: Int = 5
    @State private var showingEmojiPicker = false
    
    private let intensities = Array(1...10)
    
    var body: some View {
        NavigationView {
            VStack(spacing: themeManager.spacing) {
                // Mood Selection Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: themeManager.spacing) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        MoodButton(
                            mood: mood,
                            isSelected: selectedMood == mood,
                            action: { selectedMood = mood }
                        )
                    }
                }
                .padding(themeManager.padding)
                
                // Intensity Slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    HStack {
                        Text("1")
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        Slider(value: Binding(
                            get: { Double(selectedIntensity) },
                            set: { selectedIntensity = Int($0) }
                        ), in: 1...10, step: 1)
                        .accentColor(themeManager.accentColor)
                        
                        Text("10")
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    Text("Current: \(selectedIntensity)")
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                .padding(themeManager.padding)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .padding(.horizontal)
                
                // Custom Emoji Button
                Button {
                    showingEmojiPicker = true
                } label: {
                    HStack {
                        Image(systemName: "face.smiling")
                        Text("Choose Custom Emoji")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .foregroundColor(themeManager.accentColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Select Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
            }
            .sheet(isPresented: $showingEmojiPicker) {
                EmojiPickerView(selectedEmoji: .constant("😊"))
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
                ], spacing: themeManager.spacing) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button {
                            selectedEmoji = emoji
                            dismiss()
                        } label: {
                            Text(emoji)
                                .font(.system(size: 32))
                                .frame(maxWidth: .infinity)
                                .padding(themeManager.padding)
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
    EnhancedMoodSelectionView(selectedMood: .constant(.happy))
        .environmentObject(ThemeManager())
} 