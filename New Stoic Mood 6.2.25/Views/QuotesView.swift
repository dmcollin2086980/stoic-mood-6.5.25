import SwiftUI

struct QuotesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Stoic Quotes")
                    .font(.title)
                    .foregroundColor(themeManager.textColor)
                
                // Placeholder for quotes list
                List {
                    Text("Coming soon...")
                        .foregroundColor(themeManager.textColor)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Quotes")
            .background(themeManager.backgroundColor)
        }
    }
}

#Preview {
    QuotesView()
        .environmentObject(ThemeManager())
} 