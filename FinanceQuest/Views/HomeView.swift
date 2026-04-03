import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var contentVisible = false

    var body: some View {
        NavigationStack {
            ZStack {
                FQTheme.pathGradient.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        header
                        heroCard
                        dailyCard
                        Text("Your path")
                            .font(FQTheme.rounded(.title3, weight: .bold))
                            .foregroundStyle(FQTheme.ink)
                            .padding(.horizontal, 4)
                            .opacity(contentVisible ? 1 : 0)
                            .offset(y: contentVisible ? 0 : 12)
                            .animation(FQAnimations.snappy.delay(0.12), value: contentVisible)

                        ForEach(Array(Curriculum.main.units.enumerated()), id: \.element.id) { index, unit in
                            UnitSection(unit: unit)
                                .opacity(contentVisible ? 1 : 0)
                                .offset(y: contentVisible ? 0 : 18)
                                .animation(
                                    FQAnimations.snappy.delay(0.16 + Double(index) * 0.05),
                                    value: contentVisible
                                )
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("FinanceQuest")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                contentVisible = true
            }
        }
    }

    private var header: some View {
        HStack(spacing: 10) {
            streakPill
            Spacer(minLength: 0)
            xpPill
            gemPill
        }
        .padding(.top, 6)
        .opacity(contentVisible ? 1 : 0)
        .offset(y: contentVisible ? 0 : -8)
        .animation(FQAnimations.snappy, value: contentVisible)
    }

    private var heroCard: some View {
        HStack(alignment: .center, spacing: 16) {
            EconomistMascotView(mood: .idle, height: 118)
                .scaleEffect(contentVisible ? 1 : 0.7)
                .opacity(contentVisible ? 1 : 0)
                .animation(FQAnimations.bouncy.delay(0.04), value: contentVisible)

            VStack(alignment: .leading, spacing: 6) {
                Text(greetingLine)
                    .font(FQTheme.rounded(.title3, weight: .bold))
                    .foregroundStyle(FQTheme.ink)
                Text(Curriculum.main.subtitle)
                    .font(FQTheme.rounded(.subheadline, weight: .medium))
                    .foregroundStyle(FQTheme.ink.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.06), radius: 14, y: 5)
        )
        .opacity(contentVisible ? 1 : 0)
        .offset(y: contentVisible ? 0 : 14)
        .animation(FQAnimations.bouncy.delay(0.06), value: contentVisible)
    }

    private var greetingLine: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let prefix: String
        switch hour {
        case 5..<12: prefix = "Good morning"
        case 12..<17: prefix = "Good afternoon"
        case 17..<22: prefix = "Good evening"
        default: prefix = "Welcome back"
        }
        return "\(prefix)!"
    }

    private var streakPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .foregroundStyle(FQTheme.flameOrange)
            Text("\(game.progress.streak)")
                .font(FQTheme.rounded(.headline, weight: .bold))
                .foregroundStyle(FQTheme.ink)
            Text("day")
                .font(FQTheme.rounded(.caption, weight: .semibold))
                .foregroundStyle(FQTheme.ink.opacity(0.55))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
        )
    }

    private var xpPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.fill")
                .foregroundStyle(FQTheme.gold)
            Text("\(game.progress.xp)")
                .font(FQTheme.rounded(.subheadline, weight: .bold))
                .foregroundStyle(FQTheme.ink)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
        )
    }

    private var gemPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "diamond.fill")
                .foregroundStyle(FQTheme.skyBlue)
            Text("\(game.progress.gems)")
                .font(FQTheme.rounded(.subheadline, weight: .bold))
                .foregroundStyle(FQTheme.ink)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
        )
    }

    private var dailyCard: some View {
        let into = game.progress.xpIntoLevel
        let progress = Double(into) / 100.0

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Level progress")
                    .font(FQTheme.rounded(.headline, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("Level \(game.progress.level)")
                    .font(FQTheme.rounded(.subheadline, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                    Capsule()
                        .fill(Color.white)
                        .frame(width: max(12, geo.size.width * CGFloat(progress)))
                        .animation(FQAnimations.soft, value: progress)
                }
            }
            .frame(height: 12)
            Text("\(into) / 100 XP to the next level — finish lessons to climb faster!")
                .font(FQTheme.rounded(.caption, weight: .medium))
                .foregroundStyle(.white.opacity(0.92))
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [FQTheme.skyBlue, FQTheme.oceanBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: FQTheme.oceanBlue.opacity(0.35), radius: 12, y: 6)
        )
        .opacity(contentVisible ? 1 : 0)
        .offset(y: contentVisible ? 0 : 14)
        .animation(FQAnimations.snappy.delay(0.1), value: contentVisible)
    }
}

struct UnitSection: View {
    @EnvironmentObject private var game: GameViewModel
    let unit: Unit

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: unit.icon)
                    .font(.title2)
                    .foregroundStyle(accentColor)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(accentColor.opacity(0.18)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(unit.title)
                        .font(FQTheme.rounded(.headline, weight: .bold))
                        .foregroundStyle(FQTheme.ink)
                    ProgressView(value: game.completionRatio(for: unit))
                        .tint(accentColor)
                }
            }
            VStack(spacing: 10) {
                ForEach(unit.lessons) { lesson in
                    LessonRow(lesson: lesson, accent: accentColor)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        )
    }

    private var accentColor: Color {
        switch unit.accent {
        case .emerald: return FQTheme.primaryGreen
        case .sky: return FQTheme.skyBlue
        case .violet: return FQTheme.lilac
        case .sunset: return FQTheme.flameOrange
        case .mint: return Color(red: 0.2, green: 0.78, blue: 0.65)
        }
    }
}

struct LessonRow: View {
    @EnvironmentObject private var game: GameViewModel
    let lesson: Lesson
    let accent: Color

    var body: some View {
        Button {
            withAnimation(FQAnimations.snappy) {
                game.startLesson(lesson.id)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.2))
                        .frame(width: 44, height: 44)
                    if game.isLessonComplete(lesson.id) {
                        Image(systemName: "checkmark")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(accent)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Image(systemName: "star.fill")
                            .font(.headline)
                            .foregroundStyle(accent)
                    }
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(lesson.title)
                        .font(FQTheme.rounded(.subheadline, weight: .bold))
                        .foregroundStyle(FQTheme.ink)
                    Text(lesson.subtitle)
                        .font(FQTheme.rounded(.caption, weight: .medium))
                        .foregroundStyle(FQTheme.ink.opacity(0.55))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(FQTheme.ink.opacity(0.35))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(red: 0.97, green: 0.98, blue: 1.0))
            )
        }
        .buttonStyle(FQOptionButtonStyle(pressedScale: 0.99))
    }
}
