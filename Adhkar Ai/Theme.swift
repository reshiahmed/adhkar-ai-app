// Theme.swift — Design tokens matching the Adhkar AI PWA

import SwiftUI

// MARK: - Colors
extension Color {
    // Primary brand colors (often stable across modes)
    static let primaryGreen   = Color(hex: "1B8338")
    static let secondaryGreen = Color(hex: "4A7C59")
    static let lightGreen     = Color(hex: "E8F5EC", dark: "1B2A1F")
    
    // UI tokens (dynamic by default)
    static var appBackground: Color {
        Color(light: "EEF1F6", dark: "111827")
    }
    
    static var cardBackground: Color {
        Color(light: "FFFFFF", dark: "1F2937")
    }
    
    static var textPrimary: Color {
        Color(light: "1A1A2E", dark: "F9FAFB")
    }
    
    static var textSecondary: Color {
        Color(light: "6B7280", dark: "9CA3AF")
    }
    
    static var divider: Color {
        Color(light: "E5E7EB", dark: "374151")
    }

    static var headerBlur: Color {
        Color(light: "F5F7FA", dark: "111827").opacity(0.85)
    }
    
    static let offlineBanner     = Color(hex: "FFF3CD")  // Amber-ish offline warning
    static let offlineBannerText = Color(hex: "92400E")
    static let errorRed          = Color(hex: "EF4444")
    static let tabBarBackground  = Color(hex: "F9FAFB")

    // MARK: - Hex Initializers
    
    /// Regular Hex Init
    init(hex: String, opacity: Double = 1.0) {
        self.init(UIColor(hex: hex, opacity: opacity))
    }

    /// Dynamic (Light/Dark) Hex Init
    init(light: String, dark: String, opacity: Double = 1.0) {
        self.init(UIColor { traitCollection in
            return UIColor(hex: traitCollection.userInterfaceStyle == .dark ? dark : light, opacity: opacity)
        })
    }

    /// Convenience
    init(hex: String, dark: String?) {
        if let dark = dark {
            self.init(light: hex, dark: dark)
        } else {
            self.init(hex: hex)
        }
    }
}

// MARK: - UIColor Dynamic Helper
extension UIColor {
    convenience init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, alpha: opacity)
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
