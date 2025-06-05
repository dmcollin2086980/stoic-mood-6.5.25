import SwiftUI

struct MoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodType?
    @State private var selectedIntensity: Int = 5
    @State private var searchText = ""
    @State private var selectedCategory: MoodCategory = .positive
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var moodVM: MoodViewModel
    let onMoodSelected: (MoodType, Int) -> Void
    
    private var filteredMoods: [Mood] {
        let categoryMoods = Mood.allCases.filter { $0.category == selectedCategory }
        if searchText.isEmpty {
            return categoryMoods
        }
        return categoryMoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search Bar
                SearchBar(text: $searchText, placeholder: "Search moods...")
                    .padding(.horizontal)
                
                // Category Picker
                Picker("Category", selection: $selectedCategory) {
                    Text("Positive").tag(MoodCategory.positive)
                    Text("Neutral").tag(MoodCategory.neutral)
                    Text("Negative").tag(MoodCategory.negative)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Mood Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(filteredMoods, id: \.self) { mood in
                            MoodButton(
                                mood: mood,
                                isSelected: selectedMood == mood.toMoodType,
                                action: {
                                    selectedMood = mood.toMoodType
                                }
                            )
                        }
                    }
                    .padding()
                }
                
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
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .padding(.horizontal)
                
                // Done Button
                Button {
                    if let mood = selectedMood {
                        onMoodSelected(mood, selectedIntensity)
                        dismiss()
                    }
                } label: {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedMood != nil ? themeManager.accentColor : themeManager.accentColor.opacity(0.5))
                        .cornerRadius(ThemeManager.cornerRadius)
                }
                .disabled(selectedMood == nil)
                .padding(.horizontal)
            }
            .navigationTitle("Select Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MoodSelectionView(onMoodSelected: { _, _ in })
        .environmentObject(ThemeManager())
        .environmentObject(MoodViewModel())
} 