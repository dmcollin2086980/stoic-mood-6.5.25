import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.title)
                    .foregroundColor(themeManager.textColor)
                    .padding(.bottom, 8)
                
                Text("Last Updated: March 2024")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.bottom, 16)
                
                Group {
                    SectionView(
                        title: "Data Collection",
                        content: "We collect mood data, journal entries, and reflection responses locally on your device. This information is used solely to provide you with a personalized experience and track your progress over time.",
                        themeManager: themeManager
                    )
                    
                    SectionView(
                        title: "Data Storage",
                        content: "All data is stored locally on your device and never transmitted to external servers. Your personal information remains under your control and is not accessible to us or any third parties.",
                        themeManager: themeManager
                    )
                    
                    SectionView(
                        title: "Data Sharing",
                        content: "We do not share, sell, or transmit your personal data to third parties. Your privacy is our priority, and we maintain strict data protection practices.",
                        themeManager: themeManager
                    )
                    
                    SectionView(
                        title: "User Rights",
                        content: "You can delete all data by deleting the app. Additionally, you can clear individual entries through the app's interface. We respect your right to control your personal information.",
                        themeManager: themeManager
                    )
                }
            }
            .padding()
        }
        .background(themeManager.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
            .environmentObject(ThemeManager())
    }
} 
