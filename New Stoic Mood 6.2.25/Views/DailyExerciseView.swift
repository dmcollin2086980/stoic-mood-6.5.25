import SwiftUI
import Combine

struct DailyExerciseView: View {
    @StateObject private var viewModel = DailyExerciseViewModel()
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingSaveAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: themeManager.spacing) {
                        // Header with Quote
                        VStack(spacing: themeManager.spacing) {
                            Text(viewModel.currentExercise.quote)
                                .font(.title)
                                .foregroundColor(themeManager.textColor)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(ThemeManager.cornerRadius)
                                .accessibilityLabel("Daily Stoic Quote")
                        }
                        
                        // Exercise Content
                        VStack(alignment: .leading, spacing: themeManager.spacing) {
                            Text("Today's Exercise")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            Text(viewModel.currentExercise.exercise)
                                .font(.body)
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(ThemeManager.cornerRadius)
                                .accessibilityLabel("Exercise Description")
                        }
                        
                        // Action Steps
                        VStack(alignment: .leading, spacing: themeManager.spacing) {
                            Text("Action Steps")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            ForEach(viewModel.currentExercise.steps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 8))
                                        .foregroundColor(themeManager.accentColor)
                                        .padding(.top, 6)
                                    
                                    Text(step)
                                        .font(.body)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                            }
                        }
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(ThemeManager.cornerRadius)
                        .accessibilityLabel("Exercise Steps")
                        
                        // Reflection Section
                        if viewModel.isExerciseComplete {
                            ExerciseReflectionView(viewModel: viewModel, showingSaveAlert: $showingSaveAlert)
                            
                            NavigationLink(destination: ReflectionHistoryView()) {
                                HStack {
                                    Text("View Reflection History")
                                        .foregroundColor(themeManager.accentColor)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(ThemeManager.cornerRadius)
                            }
                            .accessibilityLabel("View Reflection History")
                        }
                        
                        // Complete Button
                        if !viewModel.isExerciseComplete {
                            Button {
                                withAnimation {
                                    viewModel.completeExercise()
                                }
                            } label: {
                                Text("Complete Exercise")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(themeManager.accentColor)
                                    .cornerRadius(ThemeManager.cornerRadius)
                            }
                            .accessibilityLabel("Complete Exercise")
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Reflection Saved", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your reflection has been saved successfully.")
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

class DailyExerciseViewModel: ObservableObject {
    @Published var currentExercise: StoicExercise
    @Published var isExerciseComplete = false
    @Published var reflectionText: String = ""
    
    init() {
        // Initialize currentExercise
        self.currentExercise = StoicExercise(
            id: UUID(),
            date: Date(),
            quote: "The happiness of your life depends upon the quality of your thoughts.",
            author: "Marcus Aurelius",
            exercise: "Practice negative visualization by imagining the loss of something you value. This exercise helps cultivate gratitude and resilience.",
            steps: [
                "Choose something you value (e.g., health, relationships, career)",
                "Imagine it being taken away",
                "Reflect on how you would cope",
                "Appreciate what you have now",
                "Write down your insights"
            ]
        )
    }
    
    func completeExercise() {
        isExerciseComplete = true
    }
}

struct StoicExercise: Identifiable {
    let id: UUID
    let date: Date
    let quote: String
    let author: String
    let exercise: String
    let steps: [String]
}

struct ExerciseReflectionView: View {
    @ObservedObject var viewModel: DailyExerciseViewModel
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var showingSaveAlert: Bool
    
    var body: some View {
        VStack(spacing: themeManager.spacing) {
            Text("Reflection Prompt")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            TextEditor(text: $viewModel.reflectionText)
                .frame(height: 120)
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .foregroundColor(themeManager.textColor)
            
            Button("Save Reflection") {
                if !viewModel.reflectionText.isEmpty {
                    reflectionVM.addReflection(
                        content: viewModel.reflectionText,
                        exercisePrompt: viewModel.currentExercise.exercise
                    )
                    viewModel.reflectionText = ""
                    showingSaveAlert = true
                }
            }
            .padding()
            .background(themeManager.accentColor)
            .foregroundColor(.white)
            .cornerRadius(ThemeManager.cornerRadius)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

struct ReflectionPromptsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    let selectedPrompt: (String) -> Void
    
    private let prompts = [
        "What insights did you gain from this exercise?",
        "How did this practice affect your perspective?",
        "What challenges did you encounter?",
        "How can you apply these insights in your daily life?",
        "What would you like to explore further?"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(prompts, id: \.self) { prompt in
                            Button {
                                selectedPrompt(prompt)
                            } label: {
                                Text(prompt)
                                    .font(.body)
                                    .foregroundColor(themeManager.textColor)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(themeManager.cardBackgroundColor)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Reflection Prompts")
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
    DailyExerciseView()
        .environmentObject(ReflectionViewModel())
        .environmentObject(ThemeManager())
} 