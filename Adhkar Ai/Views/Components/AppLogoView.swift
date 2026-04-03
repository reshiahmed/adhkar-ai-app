// AppLogoView.swift — Tasbih bead icon with blue-to-green gradient (matching PWA app icon)

import SwiftUI

struct AppLogoView: View {
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            Image("NoBackgroundLogo")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
        .shadow(color: Color.primaryGreen.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Inline logo for navigation header
struct HeaderLogoView: View {
    var body: some View {
        HStack(spacing: 10) {
            AppLogoView(size: 36)

            HStack(spacing: 0) {
                Text("Adhkar")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                Text(" AI")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primaryGreen)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AppLogoView(size: 80)
        HeaderLogoView()
    }
    .padding()
    .background(Color.appBackground)
}
