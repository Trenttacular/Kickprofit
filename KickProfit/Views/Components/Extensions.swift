import SwiftUI

// MARK: - Color Tokens

extension Color {
    static let kickBackground        = Color(hex: "#0A0A0F")
    static let kickSurface           = Color(hex: "#141420")
    static let kickSurfaceSecondary  = Color(hex: "#1C1C2E")
    static let kickAccent            = Color(hex: "#FF6B00")
    static let kickAccentLight       = Color(hex: "#FF8C33")
    static let kickWarning           = Color(hex: "#FFD60A")
    static let kickDanger            = Color(hex: "#FF453A")
    static let kickGreen             = Color(hex: "#00C853")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Formatters

extension Double {
    var asCurrency: String {
        self.formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }
    var asROI: String {
        String(format: "%+.0f%%", self * 100)
    }
    var asSignedCurrency: String {
        let magnitude = abs(self).formatted(.currency(code: "USD").precision(.fractionLength(0)))
        return self >= 0 ? "+\(magnitude)" : "-\(magnitude)"
    }
}

// MARK: - Card Modifier

struct KickCardStyle: ViewModifier {
    var padding: CGFloat = 18
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.kickSurface))
    }
}

extension View {
    func kickCard(padding: CGFloat = 18) -> some View {
        modifier(KickCardStyle(padding: padding))
    }
}

// MARK: - Press Animation

struct PressAnimationStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

// MARK: - Status Badge Color

extension FlipStatus {
    var color: Color {
        switch self {
        case .sold:    return .kickGreen
        case .listed:  return .kickAccent
        case .unwound: return .kickDanger
        }
    }
}
