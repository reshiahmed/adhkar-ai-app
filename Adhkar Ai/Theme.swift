// Theme.swift — Design tokens matching the Adhkar AI PWA

import SwiftUI

// MARK: - Colors
extension Color {
    static let primaryGreen      = Color(hex: "1B8338")  // Primary CTA, active tab, badges
    static let secondaryGreen    = Color(hex: "4A7C59")  // Transliteration text, subtle accents
    static let lightGreen        = Color(hex: "E8F5EC")  // Card tint background
    static let appBackground     = Color(hex: "EEF1F6")  // Page background (light lavender-gray)
    static let cardBackground    = Color.white
    static let headerBlur        = Color(hex: "F5F7FA").opacity(0.85) // Glassmorphism header
    static let textPrimary       = Color(hex: "1A1A2E")  // Main text (dark navy)
    static let textSecondary     = Color(hex: "6B7280")  // Subtitle / muted text
    static let tabBarBackground  = Color(hex: "F9FAFB")
    static let divider           = Color(hex: "E5E7EB")
    static let offlineBanner     = Color(hex: "FFF3CD")  // Amber-ish offline warning
    static let offlineBannerText = Color(hex: "92400E")

    // Dark mode overrides are handled automatically via asset catalog usage,
    // but primary brand colours remain the same in dark mode.
    static let darkBackground    = Color(hex: "111827")
    static let darkCard          = Color(hex: "1F2937")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red:   Double(r) / 255,
                  green: Double(g) / 255,
                  blue:  Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Typography
struct AppFont {
    // Arabic text sizes
    static let arabicLarge: CGFloat  = 26
    static let arabicMedium: CGFloat = 22

    // English text sizes
    static let title: CGFloat        = 28
    static let headline: CGFloat     = 18
    static let body: CGFloat         = 15
    static let caption: CGFloat      = 13
    static let tiny: CGFloat         = 11
}

// MARK: - Spacing & Radius
struct AppSpacing {
    static let xs: CGFloat   = 4
    static let sm: CGFloat   = 8
    static let md: CGFloat   = 16
    static let lg: CGFloat   = 24
    static let xl: CGFloat   = 32
}

struct AppRadius {
    static let sm: CGFloat  = 10
    static let md: CGFloat  = 16
    static let lg: CGFloat  = 24
    static let full: CGFloat = 100
}

// MARK: - Shadow
extension View {
    func cardShadow() -> some View {
        self.shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
    }

    func subtleShadow() -> some View {
        self.shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}
