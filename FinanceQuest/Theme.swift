import SwiftUI

enum FQAnimations {
    static let snappy = Animation.spring(response: 0.38, dampingFraction: 0.78)
    static let bouncy = Animation.spring(response: 0.52, dampingFraction: 0.68)
    static let soft = Animation.spring(response: 0.55, dampingFraction: 0.88)
    static let tab = Animation.spring(response: 0.45, dampingFraction: 0.82)
    static let cardPress = Animation.spring(response: 0.22, dampingFraction: 0.62)
}

enum FQTheme {
    static let primaryGreen = Color(red: 0.35, green: 0.80, blue: 0.01)
    static let deepGreen = Color(red: 0.22, green: 0.62, blue: 0.02)
    static let skyBlue = Color(red: 0.20, green: 0.65, blue: 0.95)
    static let oceanBlue = Color(red: 0.12, green: 0.45, blue: 0.85)
    static let flameOrange = Color(red: 1.0, green: 0.55, blue: 0.15)
    static let gold = Color(red: 1.0, green: 0.78, blue: 0.20)
    static let heartRed = Color(red: 0.95, green: 0.25, blue: 0.35)
    static let lilac = Color(red: 0.58, green: 0.45, blue: 0.95)
    static let cream = Color(red: 0.99, green: 0.98, blue: 0.95)
    static let ink = Color(red: 0.15, green: 0.16, blue: 0.22)

    static let pathGradient = LinearGradient(
        colors: [Color(red: 0.93, green: 0.96, blue: 1.0), cream],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func rounded(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        .system(style, design: .rounded).weight(weight)
    }
}

struct FQPrimaryButtonStyle: ButtonStyle {
    var color: Color = FQTheme.primaryGreen

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FQTheme.rounded(.headline, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
                    .shadow(color: color.opacity(0.45), radius: configuration.isPressed ? 2 : 6, y: configuration.isPressed ? 1 : 4)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct FQSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FQTheme.rounded(.subheadline, weight: .semibold))
            .foregroundStyle(FQTheme.oceanBlue)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct FQOptionButtonStyle: ButtonStyle {
    var pressedScale: CGFloat = 0.98

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .animation(FQAnimations.cardPress, value: configuration.isPressed)
    }
}
