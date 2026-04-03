import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var game: GameViewModel
    @State private var tab: Int = 0

    private var lessonPresented: Bool {
        switch game.phase {
        case .idle: return false
        default: return true
        }
    }

    var body: some View {
        Group {
            switch tab {
            case 0:
                HomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            default:
                ProfileView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .animation(FQAnimations.tab, value: tab)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !lessonPresented {
                customTabBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(FQAnimations.soft, value: lessonPresented)
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: Binding(
            get: { lessonPresented },
            set: { if !$0 { game.exitLesson() } }
        )) {
            Group {
                switch game.phase {
                case .idle:
                    Color.clear
                case .active(let lessonId, _, _):
                    LessonSessionView(lessonId: lessonId)
                        .environmentObject(game)
                case .result(_, let passed, let xp):
                    LessonResultView(passed: passed, xpEarned: xp)
                        .environmentObject(game)
                }
            }
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, title: "Learn", systemImage: "map.fill")
            tabButton(index: 1, title: "Profile", systemImage: "person.crop.circle.fill")
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 16, y: -4)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 6)
    }

    private func tabButton(index: Int, title: String, systemImage: String) -> some View {
        let selected = tab == index
        return Button {
            withAnimation(FQAnimations.tab) {
                tab = index
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(FQTheme.rounded(.subheadline, weight: .bold))
            }
            .foregroundStyle(selected ? Color.white : FQTheme.ink.opacity(0.45))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                if selected {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [FQTheme.primaryGreen, FQTheme.deepGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }
}
