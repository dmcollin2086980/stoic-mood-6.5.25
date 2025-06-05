import SwiftUI

enum ThemeType: String, CaseIterable, Identifiable {
    case classicStoic = "Classic Stoic"
    case warmEarth = "Warm Earth"
    case oceanCalm = "Ocean Calm"
    case forestSage = "Forest Sage"
    case sunsetGlow = "Sunset Glow"
    case midnightDeep = "Midnight Deep"
    case pureLight = "Pure Light"
    case goldenWisdom = "Golden Wisdom"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .classicStoic:
            return "Traditional grays and muted blues for a timeless Stoic experience"
        case .warmEarth:
            return "Natural browns and terracotta tones for grounding reflection"
        case .oceanCalm:
            return "Tranquil blues and teals for peaceful contemplation"
        case .forestSage:
            return "Grounding greens and earth tones for wisdom and growth"
        case .sunsetGlow:
            return "Warm oranges and purples for inspiring moments"
        case .midnightDeep:
            return "Dark purples and blues for deep contemplation"
        case .pureLight:
            return "Clean whites and grays for clarity and focus"
        case .goldenWisdom:
            return "Warm golds and ambers for enlightened insights"
        }
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    static let cornerRadius: CGFloat = 12
    static let spacing: CGFloat = 16
    
    @Published var currentTheme: ThemeType {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? ThemeType.classicStoic.rawValue
        self.currentTheme = ThemeType(rawValue: savedTheme) ?? .classicStoic
    }
    
    // MARK: - Theme Colors
    
    var backgroundColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "F5F5F5")
        case .warmEarth:
            return Color(hex: "F5F0E6")
        case .oceanCalm:
            return Color(hex: "F0F5F5")
        case .forestSage:
            return Color(hex: "F0F5F0")
        case .sunsetGlow:
            return Color(hex: "F5F0F0")
        case .midnightDeep:
            return Color(hex: "1A1A2E")
        case .pureLight:
            return Color(hex: "FFFFFF")
        case .goldenWisdom:
            return Color(hex: "F5F0E0")
        }
    }
    
    var cardBackgroundColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "FFFFFF")
        case .warmEarth:
            return Color(hex: "FFFFFF")
        case .oceanCalm:
            return Color(hex: "FFFFFF")
        case .forestSage:
            return Color(hex: "FFFFFF")
        case .sunsetGlow:
            return Color(hex: "FFFFFF")
        case .midnightDeep:
            return Color(hex: "252A40")
        case .pureLight:
            return Color(hex: "F8F8F8")
        case .goldenWisdom:
            return Color(hex: "FFFFFF")
        }
    }
    
    var textColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "2C3E50")
        case .warmEarth:
            return Color(hex: "4A3C31")
        case .oceanCalm:
            return Color(hex: "1A3C4A")
        case .forestSage:
            return Color(hex: "2C4A3C")
        case .sunsetGlow:
            return Color(hex: "4A3C31")
        case .midnightDeep:
            return Color(hex: "E0E0E0")
        case .pureLight:
            return Color(hex: "2C3E50")
        case .goldenWisdom:
            return Color(hex: "4A3C31")
        }
    }
    
    var secondaryTextColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "7F8C8D")
        case .warmEarth:
            return Color(hex: "8C7F6D")
        case .oceanCalm:
            return Color(hex: "6D8C9C")
        case .forestSage:
            return Color(hex: "6D8C7F")
        case .sunsetGlow:
            return Color(hex: "8C7F6D")
        case .midnightDeep:
            return Color(hex: "B0B0B0")
        case .pureLight:
            return Color(hex: "7F8C8D")
        case .goldenWisdom:
            return Color(hex: "8C7F6D")
        }
    }
    
    var accentColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "3498DB")
        case .warmEarth:
            return Color(hex: "D4A373")
        case .oceanCalm:
            return Color(hex: "2E86C1")
        case .forestSage:
            return Color(hex: "2E8B57")
        case .sunsetGlow:
            return Color(hex: "E67E22")
        case .midnightDeep:
            return Color(hex: "9B59B6")
        case .pureLight:
            return Color(hex: "3498DB")
        case .goldenWisdom:
            return Color(hex: "D4AF37")
        }
    }
    
    var buttonColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "3498DB")
        case .warmEarth:
            return Color(hex: "D4A373")
        case .oceanCalm:
            return Color(hex: "2E86C1")
        case .forestSage:
            return Color(hex: "2E8B57")
        case .sunsetGlow:
            return Color(hex: "E67E22")
        case .midnightDeep:
            return Color(hex: "9B59B6")
        case .pureLight:
            return Color(hex: "3498DB")
        case .goldenWisdom:
            return Color(hex: "D4AF37")
        }
    }
    
    var disabledButtonColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "BDC3C7")
        case .warmEarth:
            return Color(hex: "D3C5B5")
        case .oceanCalm:
            return Color(hex: "B5C5D3")
        case .forestSage:
            return Color(hex: "B5D3C5")
        case .sunsetGlow:
            return Color(hex: "D3B5B5")
        case .midnightDeep:
            return Color(hex: "4A4A6A")
        case .pureLight:
            return Color(hex: "BDC3C7")
        case .goldenWisdom:
            return Color(hex: "D3C5B5")
        }
    }
    
    var borderColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "E0E0E0")
        case .warmEarth:
            return Color(hex: "E6D5C3")
        case .oceanCalm:
            return Color(hex: "C3D5E6")
        case .forestSage:
            return Color(hex: "C3E6D5")
        case .sunsetGlow:
            return Color(hex: "E6C3C3")
        case .midnightDeep:
            return Color(hex: "3A3A5A")
        case .pureLight:
            return Color(hex: "E0E0E0")
        case .goldenWisdom:
            return Color(hex: "E6D5C3")
        }
    }
    
    var dividerColor: Color {
        switch currentTheme {
        case .classicStoic:
            return Color(hex: "ECF0F1")
        case .warmEarth:
            return Color(hex: "F0E6D5")
        case .oceanCalm:
            return Color(hex: "D5E6F0")
        case .forestSage:
            return Color(hex: "D5F0E6")
        case .sunsetGlow:
            return Color(hex: "F0D5D5")
        case .midnightDeep:
            return Color(hex: "2A2A4A")
        case .pureLight:
            return Color(hex: "ECF0F1")
        case .goldenWisdom:
            return Color(hex: "F0E6D5")
        }
    }
    
    // MARK: - Theme Preview Colors
    
    func previewColors(for theme: ThemeType) -> [Color] {
        switch theme {
        case .classicStoic:
            return [
                Color(hex: "F5F5F5"),
                Color(hex: "3498DB"),
                Color(hex: "2C3E50"),
                Color(hex: "7F8C8D")
            ]
        case .warmEarth:
            return [
                Color(hex: "F5F0E6"),
                Color(hex: "D4A373"),
                Color(hex: "4A3C31"),
                Color(hex: "8C7F6D")
            ]
        case .oceanCalm:
            return [
                Color(hex: "F0F5F5"),
                Color(hex: "2E86C1"),
                Color(hex: "1A3C4A"),
                Color(hex: "6D8C9C")
            ]
        case .forestSage:
            return [
                Color(hex: "F0F5F0"),
                Color(hex: "2E8B57"),
                Color(hex: "2C4A3C"),
                Color(hex: "6D8C7F")
            ]
        case .sunsetGlow:
            return [
                Color(hex: "F5F0F0"),
                Color(hex: "E67E22"),
                Color(hex: "4A3C31"),
                Color(hex: "8C7F6D")
            ]
        case .midnightDeep:
            return [
                Color(hex: "1A1A2E"),
                Color(hex: "9B59B6"),
                Color(hex: "E0E0E0"),
                Color(hex: "B0B0B0")
            ]
        case .pureLight:
            return [
                Color(hex: "FFFFFF"),
                Color(hex: "3498DB"),
                Color(hex: "2C3E50"),
                Color(hex: "7F8C8D")
            ]
        case .goldenWisdom:
            return [
                Color(hex: "F5F0E0"),
                Color(hex: "D4AF37"),
                Color(hex: "4A3C31"),
                Color(hex: "8C7F6D")
            ]
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 