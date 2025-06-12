import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(ThemeType.allCases) { theme in
                            ThemePreviewCard(
                                theme: theme,
                                isSelected: themeManager.currentTheme == theme,
                                colors: themeManager.previewColors(for: theme)
                            )
                            .onTapGesture {
                                withAnimation {
                                    themeManager.currentTheme = theme
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ThemePreviewCard: View {
    let theme: ThemeType
    let isSelected: Bool
    let colors: [Color]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Color Swatches
            HStack(spacing: 4) {
                ForEach(colors, id: \.self) { color in
                    color
                        .frame(height: 24)
                        .cornerRadius(4)
                }
            }
            
            // Theme Name
            Text(theme.rawValue)
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            // Theme Description
            Text(theme.description)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
                .lineLimit(2)
            
            // Selection Indicator
            if isSelected {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(themeManager.accentColor)
                    Text("Current Theme")
                        .font(.caption)
                        .foregroundColor(themeManager.accentColor)
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                .stroke(isSelected ? themeManager.accentColor : themeManager.borderColor, lineWidth: isSelected ? 2 : 1)
        )
    }
}

#Preview {
    ThemeSelectionView()
        .environmentObject(ThemeManager())
} 
