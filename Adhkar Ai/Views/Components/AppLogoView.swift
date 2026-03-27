// AppLogoView.swift — Tasbih bead icon with blue-to-green gradient (matching PWA app icon)

import SwiftUI

struct AppLogoView: View {
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            // Gradient background matching the PWA app icon (blue-to-green)
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "4BA8D9"), Color(hex: "3CB87A"), Color(hex: "1B8338")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)

            // Tasbih beads using SF Symbol
            Image(systemName: "circle.grid.3x3.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.52)
                .foregroundColor(.white.opacity(0.9))
        }
        .shadow(color: Color.primaryGreen.opacity(0.35), radius: 10, x: 0, y: 5)
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
