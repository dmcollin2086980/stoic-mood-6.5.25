import SwiftUI

struct ReflectionHistoryView: View {
    @EnvironmentObject var reflectionVM: ReflectionViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var reflectionToDelete: Reflection?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            if reflectionVM.reflections.isEmpty {
                Text("No reflections yet")
                    .foregroundColor(themeManager.secondaryTextColor)
                    .italic()
            } else {
                ForEach(reflectionVM.reflections) { reflection in
                    NavigationLink(destination: ReflectionDetailView(reflection: reflection)) {
                        VStack(alignment: .leading, spacing: 12) {
                            // Date
                            Text(reflection.date.formatted(date: .long, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(themeManager.secondaryTextColor)
                            
                            // Exercise Prompt
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Today's Exercise:")
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Text(reflection.exercisePrompt)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .italic()
                            }
                            
                            // Reflection Response
                            Text(reflection.content)
                                .font(.body)
                                .foregroundColor(themeManager.textColor)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        reflectionToDelete = reflectionVM.reflections[index]
                        showingDeleteAlert = true
                    }
                }
            }
        }
        .navigationTitle("Reflection History")
        .alert("Delete Reflection", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let reflection = reflectionToDelete {
                    reflectionVM.deleteReflection(reflection)
                }
            }
        } message: {
            Text("Are you sure you want to delete this reflection? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationView {
        ReflectionHistoryView()
            .environmentObject(ReflectionViewModel())
            .environmentObject(ThemeManager())
    }
}

