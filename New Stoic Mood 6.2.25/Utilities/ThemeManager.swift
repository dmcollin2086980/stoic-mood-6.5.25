import SwiftUI

/// A manager class that handles theme-related functionality and styling for the app.
/// This class provides access to colors, spacing, and styling modifiers that can be used
/// throughout the app to maintain consistent design.
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    static let cornerRadius: CGFloat = 12
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    // System colors
    var backgroundColor: Color {
        Color(.systemBackground)
    }
    
    var cardBackgroundColor: Color {
        Color(.secondarySystemBackground)
    }
    
    var textColor: Color {
        Color(.label)
    }
    
    var secondaryTextColor: Color {
        Color(.secondaryLabel)
    }
    
    var borderColor: Color {
        Color(.separator)
    }
    
    var accentColor: Color {
        Color.accentColor
    }
    
    // Layout constants
    let spacing: CGFloat = 16
    let padding: CGFloat = 16
    let iconSize: CGFloat = 24
    let buttonHeight: CGFloat = 44
    let cardPadding: CGFloat = 16
    let shadowRadius: CGFloat = 4
    let shadowOpacity: Double = 0.1
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    // MARK: - Colors
    
    /// A secondary accent color used for less prominent interactive elements
    var secondaryAccentColor: Color { Color("SecondaryAccentColor") }
    
    /// The color used to indicate success states
    var successColor: Color { Color("SuccessColor") }
    
    /// The color used to indicate warning states
    var warningColor: Color { Color("WarningColor") }
    
    /// The color used to indicate error states
    var errorColor: Color { Color("ErrorColor") }
    
    var shadowColor: Color {
        Color.black.opacity(0.1)
    }
    
    // MARK: - View Modifiers
    
    /// Applies the primary button style to a view
    /// - Returns: A view with the primary button style applied
    func primaryButtonStyle() -> some ViewModifier {
        PrimaryButtonStyleModifier(themeManager: self)
    }
    
    /// Applies the secondary button style to a view
    /// - Returns: A view with the secondary button style applied
    func secondaryButtonStyle() -> some ViewModifier {
        SecondaryButtonStyleModifier(themeManager: self)
    }
}

// MARK: - View Modifiers
struct PrimaryButtonStyleModifier: ViewModifier {
    @ObservedObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeManager.accentColor)
            .foregroundColor(themeManager.backgroundColor)
            .cornerRadius(ThemeManager.cornerRadius)
            .shadow(color: themeManager.shadowColor, radius: 5, x: 0, y: 2)
    }
}

struct SecondaryButtonStyleModifier: ViewModifier {
    @ObservedObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeManager.cardBackgroundColor)
            .foregroundColor(themeManager.accentColor)
            .cornerRadius(ThemeManager.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                    .stroke(themeManager.accentColor, lineWidth: 1)
            )
    }
}

// MARK: - View Extensions
extension View {
    /// Applies the theme background color to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme background color applied
    func themeBackground(themeManager: ThemeManager) -> some View {
        self.background(themeManager.backgroundColor)
    }
    
    /// Applies the theme text color to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme text color applied
    func themeText(themeManager: ThemeManager) -> some View {
        self.foregroundColor(themeManager.textColor)
    }
    
    /// Applies the theme card style to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme card style applied
    func themeCard(themeManager: ThemeManager) -> some View {
        self.cardStyle()
    }
    
    /// Applies the theme primary button style to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme primary button style applied
    func themePrimaryButton(themeManager: ThemeManager) -> some View {
        self.modifier(themeManager.primaryButtonStyle())
    }
    
    /// Applies the theme secondary button style to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme secondary button style applied
    func themeSecondaryButton(themeManager: ThemeManager) -> some View {
        self.modifier(themeManager.secondaryButtonStyle())
    }
}

// MARK: - Color Extensions
extension Color {
    static let systemBackground = Color(.systemBackground)
    static let secondarySystemBackground = Color(.secondarySystemBackground)
    static let tertiarySystemBackground = Color(.tertiarySystemBackground)
    static let systemGroupedBackground = Color(.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(.secondarySystemGroupedBackground)
    
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let tertiaryLabel = Color(.tertiaryLabel)
    static let quaternaryLabel = Color(.quaternaryLabel)
    
    static let separator = Color(.separator)
    static let opaqueSeparator = Color(.opaqueSeparator)
    
    static let systemFill = Color(.systemFill)
    static let secondarySystemFill = Color(.secondarySystemFill)
    static let tertiarySystemFill = Color(.tertiarySystemFill)
    static let quaternarySystemFill = Color(.quaternarySystemFill)
} 
