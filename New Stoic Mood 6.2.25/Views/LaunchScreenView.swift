import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            // Match your app's theme background
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image("AppIcon")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(radius: 10)
                Text("Stoic Mood")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
