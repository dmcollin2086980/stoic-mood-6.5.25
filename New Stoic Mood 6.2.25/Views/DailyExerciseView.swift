import SwiftUI
import Combine

struct DailyExerciseView: View {
    @StateObject private var viewModel = DailyExerciseViewModel()
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingSaveAlert = false
    @EnvironmentObject private var exerciseVM: ExerciseViewModel
    @State private var showingHistory = false
    @State private var selectedPrompt: String?
    @State private var showingPrompts = false
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: ThemeManager.padding) {
                    // Header with Quote
                    VStack(spacing: ThemeManager.padding) {
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
                    VStack(alignment: .leading, spacing: ThemeManager.padding) {
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
                    VStack(alignment: .leading, spacing: ThemeManager.padding) {
                        Text("Action Steps")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        ForEach(viewModel.currentExercise.steps, id: \.self) { step in
                            HStack(alignment: .top, spacing: ThemeManager.smallPadding) {
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingHistory = true
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(themeManager.accentColor)
                }
            }
        }
        .alert("Reflection Saved", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your reflection has been saved successfully.")
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .sheet(isPresented: $showingHistory) {
            NavigationView {
                ExerciseHistoryView()
            }
        }
        .sheet(isPresented: $showingPrompts) {
            ReflectionPromptsView(selectedPrompt: $selectedPrompt)
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

struct ExerciseReflectionView: View {
    @ObservedObject var viewModel: DailyExerciseViewModel
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var showingSaveAlert: Bool
    @State private var showingPrompts = false
    @State private var selectedPrompt: String?
    
    var body: some View {
        VStack(spacing: ThemeManager.padding) {
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
        .sheet(isPresented: $showingPrompts) {
            ReflectionPromptsView(selectedPrompt: $selectedPrompt)
        }
    }
}

#Preview {
    DailyExerciseView()
        .environmentObject(ThemeManager())
        .environmentObject(ReflectionViewModel())
        .environmentObject(ExerciseViewModel())
} 
