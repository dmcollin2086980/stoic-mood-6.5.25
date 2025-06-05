import SwiftUI

struct ExerciseHistoryView: View {
    @EnvironmentObject var exerciseVM: ExerciseViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var searchText = ""
    
    private var filteredExercises: [ExerciseEntry] {
        if searchText.isEmpty {
            return exerciseVM.exercises
        } else {
            return exerciseVM.exercises.filter { exercise in
                exercise.prompt.localizedCaseInsensitiveContains(searchText) ||
                exercise.response.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: themeManager.spacing) {
                // Streak Summary
                HStack {
                    VStack(alignment: .leading) {
                        Text("Exercise Streak")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        Text("\(exerciseVM.exercises.count) exercises completed")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    Spacer()
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(themeManager.secondaryTextColor)
                    TextField("Search exercises...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Exercise List
                if filteredExercises.isEmpty {
                    Text("No exercises found")
                        .foregroundColor(themeManager.secondaryTextColor)
                        .italic()
                        .padding()
                } else {
                    LazyVStack(spacing: themeManager.spacing) {
                        ForEach(filteredExercises) { exercise in
                            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                                ExerciseHistoryCard(exercise: exercise, themeManager: themeManager)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(themeManager.backgroundColor)
        .navigationTitle("Exercise History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseHistoryCard: View {
    let exercise: ExerciseEntry
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date
            Text(exercise.date.formatted(date: .long, time: .omitted))
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
            
            // Exercise Prompt
            VStack(alignment: .leading, spacing: 4) {
                Text("Exercise:")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text(exercise.prompt)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(2)
            }
            
            // Response Preview
            VStack(alignment: .leading, spacing: 4) {
                Text("Response:")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                
                Text(exercise.response)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

struct ExerciseDetailView: View {
    let exercise: ExerciseEntry
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Date
                Text(exercise.date.formatted(date: .long, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                
                // Exercise Prompt
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercise Prompt:")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(exercise.prompt)
                        .font(.body)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .italic()
                }
                
                // Response
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Response:")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(exercise.response)
                        .font(.body)
                        .foregroundColor(themeManager.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .background(themeManager.backgroundColor)
        .navigationTitle("Exercise Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ExerciseHistoryView()
            .environmentObject(ExerciseViewModel())
            .environmentObject(ThemeManager())
    }
} 