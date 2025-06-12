import SwiftUI

struct TermsOfServiceView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Service")
                    .font(.title)
                    .foregroundColor(themeManager.textColor)
                    .padding(.bottom, 8)
                
                Text("Last Updated: March 2024")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.bottom, 16)
                
                Group {
                    SectionView(
                        title: "App Purpose",
                        content: "This app is designed for personal mood tracking and reflection. It provides tools and resources to help you develop mindfulness and emotional awareness through daily practice.",
                        themeManager: themeManager
                    )
                    
                    SectionView(
                        title: "User Responsibilities",
                        content: "Use this app as a supplement to, not replacement for, professional mental health care. You are responsible for your own well-being and should seek professional help when needed.",
                        themeManager: themeManager
                    )
                    
                    SectionView(
                        title: "Medical Disclaimer",
                        content: "This app is not intended to diagnose, treat, or cure any medical condition. The content provided is for educational and self-reflection purposes only.",
                        themeManager: themeManager
                    )
                    
                    SectionView(
                        title: "Contact Information",
                        content: "For support, contact: support@stoicmood.app. We aim to respond to all inquiries within 48 hours during business days.",
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
        TermsOfServiceView()
            .environmentObject(ThemeManager())
    }
} 
