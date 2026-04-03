import SwiftUI

enum MascotMood: Equatable {
    case idle
    case curious
    case thinking
    case delighted
    case oops
    case cheering

    var tiltDegrees: Double {
        switch self {
        case .idle: return 0
        case .curious: return -6
        case .thinking: return 4
        case .delighted: return -3
        case .oops: return 8
        case .cheering: return -4
        }
    }

    var extraScale: CGFloat {
        switch self {
        case .delighted, .cheering: return 1.12
        case .oops: return 0.94
        default: return 1.0
        }
    }

    var mouthSmile: CGFloat {
        switch self {
        case .idle, .curious: return 0.35
        case .thinking: return 0.1
        case .delighted, .cheering: return 0.65
        case .oops: return -0.4
        }
    }
}

struct EconomistMascotView: View {
    var mood: MascotMood
    /// Total height of the figure (width scales proportionally).
    var height: CGFloat = 140

    @State private var bob: CGFloat = 0
    @State private var wave: Double = 0

    private var w: CGFloat { height * 0.72 }

    var body: some View {
        let skin = Color(red: 0.96, green: 0.82, blue: 0.72)
        let suit = Color(red: 0.18, green: 0.22, blue: 0.38)
        let hair = Color(red: 0.28, green: 0.2, blue: 0.16)

        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.12))
                .frame(width: w * 0.55, height: height * 0.08)
                .offset(y: height * 0.46)

            ZStack {
                RoundedRectangle(cornerRadius: w * 0.12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [suit, suit.opacity(0.85)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 0.62, height: height * 0.42)
                    .offset(y: height * 0.12)

                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(FQTheme.heartRed.opacity(0.9))
                    .frame(width: w * 0.12, height: height * 0.22)
                    .offset(y: height * 0.08)

                chartPaper
                    .offset(x: w * 0.38, y: height * 0.02)
                    .rotationEffect(.degrees(wave * 6 + (mood == .cheering ? 12 : 0)))

                headGroup(skin: skin, hair: hair)
                    .offset(y: -height * 0.28)
            }
            .rotationEffect(.degrees(mood.tiltDegrees))
            .scaleEffect(mood.extraScale)
            .offset(y: bob)
        }
        .frame(width: w, height: height)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                bob = -5
            }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                wave = 1
            }
        }
        .animation(FQAnimations.bouncy, value: mood)
    }

    private var chartPaper: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(Color.white)
            .frame(width: w * 0.28, height: height * 0.26)
            .overlay(
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(0..<4, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(FQTheme.skyBlue.opacity(0.35 + Double(i) * 0.12))
                            .frame(width: w * (0.18 + CGFloat(i) * 0.02), height: 5)
                    }
                }
                .padding(6)
            )
            .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
    }

    private func headGroup(skin: Color, hair: Color) -> some View {
        ZStack {
            Ellipse()
                .fill(hair)
                .frame(width: w * 0.52, height: w * 0.22)
                .offset(y: -w * 0.2)

            Circle()
                .fill(
                    LinearGradient(colors: [skin, skin.opacity(0.92)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: w * 0.5, height: w * 0.5)

            glasses(width: w * 0.42)
                .offset(y: -w * 0.02)

            eyesAndBrows(width: w)

            mouthCurve(width: w)
                .stroke(FQTheme.ink.opacity(0.55), style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
                .offset(y: w * 0.12)
        }
    }

    private func glasses(width: CGFloat) -> some View {
        HStack(spacing: width * 0.04) {
            lens
            lens
        }
        .overlay(
            Rectangle()
                .fill(FQTheme.ink.opacity(0.5))
                .frame(width: width * 0.08, height: 2)
                .offset(y: -width * 0.02)
        )
    }

    private var lens: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.28))
            Circle()
                .stroke(FQTheme.ink.opacity(0.65), lineWidth: 2.5)
        }
        .frame(width: w * 0.2, height: w * 0.2)
    }

    private func eyesAndBrows(width: CGFloat) -> some View {
        let eyeY: CGFloat = -width * 0.02
        return ZStack {
            HStack(spacing: width * 0.14) {
                eye(open: mood != .thinking)
                eye(open: true)
            }
            .offset(y: eyeY)

            HStack(spacing: width * 0.16) {
                brow
                brow
            }
            .offset(y: eyeY - width * 0.1)
        }
    }

    private func eye(open: Bool) -> some View {
        Group {
            if open {
                Circle()
                    .fill(FQTheme.ink.opacity(0.75))
                    .frame(width: w * 0.07, height: w * 0.07)
            } else {
                Capsule()
                    .fill(FQTheme.ink.opacity(0.75))
                    .frame(width: w * 0.09, height: 2.5)
            }
        }
    }

    private var brow: some View {
        Capsule()
            .fill(FQTheme.ink.opacity(0.35))
            .frame(width: w * 0.12, height: 3)
    }

    private func mouthCurve(width: CGFloat) -> Path {
        var p = Path()
        let half = width * 0.11
        let smile = mood.mouthSmile
        p.move(to: CGPoint(x: -half, y: 0))
        p.addQuadCurve(
            to: CGPoint(x: half, y: 0),
            control: CGPoint(x: 0, y: -9 * smile)
        )
        return p
    }
}

#Preview {
    VStack(spacing: 24) {
        EconomistMascotView(mood: .idle)
        EconomistMascotView(mood: .delighted, height: 100)
    }
    .padding()
    .background(FQTheme.pathGradient)
}
