import SwiftUI

struct ReflectionPromptsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var selectedPrompt: String?
    @Environment(\.dismiss) private var dismiss
    
    private let prompts = [
        "What aspects of today am I grateful for?",
        "How did I practice virtue today?",
        "What could I have done better today?",
        "What did I learn about myself today?",
        "How did I handle challenges today?",
        "What am I looking forward to tomorrow?",
        "How did I show kindness today?",
        "What made me feel peaceful today?",
        "How did I grow today?",
        "What would I like to improve tomorrow?"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: ThemeManager.padding) {
                    ForEach(prompts, id: \.self) { prompt in
                        Button {
                            selectedPrompt = prompt
                            dismiss()
                        } label: {
                            Text(prompt)
                                .font(.body)
                                .foregroundColor(themeManager.textColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(ThemeManager.cornerRadius)
                        }
                    }
                }
                .padding()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Reflection Prompts")
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

struct ReflectionPromptsView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectionPromptsView(selectedPrompt: .constant(nil))
            .environmentObject(ThemeManager())
    }
} 
