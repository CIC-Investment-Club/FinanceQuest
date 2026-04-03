import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ZStack {
                FQTheme.pathGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        avatarCard
                        statsGrid
                        tipCard
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                appeared = true
            }
        }
    }

    private var avatarCard: some View {
        VStack(spacing: 14) {
            EconomistMascotView(mood: .idle, height: 132)
                .scaleEffect(appeared ? 1 : 0.75)
                .opacity(appeared ? 1 : 0)
                .animation(FQAnimations.bouncy.delay(0.04), value: appeared)

            Text("Dr. Thrift")
                .font(FQTheme.rounded(.title2, weight: .bold))
                .foregroundStyle(FQTheme.ink)
            Text("Your guide through money basics")
                .font(FQTheme.rounded(.subheadline, weight: .medium))
                .foregroundStyle(FQTheme.ink.opacity(0.55))

            HStack(spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .foregroundStyle(FQTheme.gold)
                Text("Level \(game.progress.level)")
                    .font(FQTheme.rounded(.headline, weight: .bold))
                    .foregroundStyle(FQTheme.ink)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(FQTheme.gold.opacity(0.18))
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(FQAnimations.snappy.delay(0.06), value: appeared)
    }

    private var statsGrid: some View {
        let completed = game.progress.completedLessonIds.count
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statTile(title: "Total XP", value: "\(game.progress.xp)", icon: "bolt.fill", color: FQTheme.gold)
            statTile(title: "Gems", value: "\(game.progress.gems)", icon: "diamond.fill", color: FQTheme.skyBlue)
            statTile(title: "Streak", value: "\(game.progress.streak) days", icon: "flame.fill", color: FQTheme.flameOrange)
            statTile(title: "Lessons", value: "\(completed)", icon: "checkmark.seal.fill", color: FQTheme.primaryGreen)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 16)
        .animation(FQAnimations.snappy.delay(0.12), value: appeared)
    }

    private func statTile(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
            Text(title)
                .font(FQTheme.rounded(.caption, weight: .semibold))
                .foregroundStyle(FQTheme.ink.opacity(0.45))
            Text(value)
                .font(FQTheme.rounded(.title3, weight: .bold))
                .foregroundStyle(FQTheme.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
        )
    }

    private var tipCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Friendly reminder", systemImage: "hand.wave.fill")
                .font(FQTheme.rounded(.headline, weight: .bold))
                .foregroundStyle(FQTheme.oceanBlue)
            Text("FinanceQuest teaches concepts for everyday confidence—not personalized financial advice. For big decisions, talk to a qualified professional.")
                .font(FQTheme.rounded(.subheadline, weight: .medium))
                .foregroundStyle(FQTheme.ink.opacity(0.7))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 0.95, green: 0.97, blue: 1.0))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(FQTheme.skyBlue.opacity(0.25), lineWidth: 1)
                )
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(FQAnimations.snappy.delay(0.18), value: appeared)
    }
}
