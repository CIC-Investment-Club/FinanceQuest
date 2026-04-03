import SwiftUI

struct LessonSessionView: View {
    @EnvironmentObject private var game: GameViewModel
    let lessonId: String

    var body: some View {
        Group {
            if let lesson = Curriculum.lesson(byId: lessonId),
               case .active(_, let index, let hearts) = game.phase {
                questionScreen(lesson: lesson, index: index, hearts: hearts)
            } else {
                Color.clear.onAppear { game.exitLesson() }
            }
        }
    }

    @ViewBuilder
    private func questionScreen(lesson: Lesson, index: Int, hearts: Int) -> some View {
        let q = lesson.questions[index]
        let qid = "\(lesson.id)-q-\(index)"

        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.97, blue: 1.0),
                    FQTheme.cream
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar(hearts: hearts, lesson: lesson, index: index)
                EconomistMascotView(mood: game.mascotMood, height: 100)
                    .padding(.top, 4)
                    .padding(.bottom, 2)
                    .transition(.scale.combined(with: .opacity))

                Group {
                    Text("QUESTION \(index + 1) OF \(lesson.questions.count)")
                        .font(FQTheme.rounded(.caption, weight: .bold))
                        .foregroundStyle(FQTheme.ink.opacity(0.45))
                        .padding(.bottom, 8)
                    Text(q.prompt)
                        .font(FQTheme.rounded(.title3, weight: .bold))
                        .foregroundStyle(FQTheme.ink)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                    Spacer(minLength: 16)
                    optionsList(q: q, questionIndex: index)
                    Spacer()
                    if game.showExplanation {
                        explanationCard(q: q)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        continueButton(lessonId: lesson.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .id(qid)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
                .animation(FQAnimations.snappy, value: qid)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 12)
        }
        .modifier(ShakeEffect(animates: game.shakeWrong))
    }

    private func topBar(hearts: Int, lesson: Lesson, index: Int) -> some View {
        let total = lesson.questions.count

        return VStack(spacing: 10) {
            HStack {
                Button {
                    withAnimation(FQAnimations.soft) {
                        game.exitLesson()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(FQTheme.ink.opacity(0.55))
                        .padding(10)
                        .background(Circle().fill(Color.white.opacity(0.9)))
                }
                Spacer()
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < hearts ? "heart.fill" : "heart")
                            .foregroundStyle(i < hearts ? FQTheme.heartRed : Color.gray.opacity(0.35))
                            .font(.title3)
                            .scaleEffect(i < hearts ? 1 : 0.85)
                            .animation(FQAnimations.bouncy, value: hearts)
                    }
                }
                Spacer()
                Text("\(index + 1)/\(total)")
                    .font(FQTheme.rounded(.subheadline, weight: .bold))
                    .foregroundStyle(FQTheme.ink.opacity(0.45))
            }
            .padding(.top, 8)

            GeometryReader { geo in
                let fill = Double(index + 1) / Double(max(total, 1))
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.65))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [FQTheme.primaryGreen, FQTheme.deepGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(8, geo.size.width * fill))
                        .animation(FQAnimations.soft, value: index)
                }
            }
            .frame(height: 8)
        }
    }

    private func optionsList(q: QuizQuestion, questionIndex: Int) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(q.options.enumerated()), id: \.offset) { offset, text in
                optionButton(q: q, questionIndex: questionIndex, offset: offset, text: text)
            }
        }
    }

    private func optionButton(q: QuizQuestion, questionIndex: Int, offset: Int, text: String) -> some View {
        let locked = game.showExplanation
        let selected = game.selectedOption == offset
        let correct = offset == q.correctIndex
        let showResult = game.showExplanation

        var border: Color = Color.black.opacity(0.08)
        var bg: Color = Color.white.opacity(0.95)
        if showResult {
            if correct {
                border = FQTheme.primaryGreen
                bg = FQTheme.primaryGreen.opacity(0.15)
            } else if selected && !correct {
                border = FQTheme.heartRed
                bg = FQTheme.heartRed.opacity(0.12)
            }
        }

        return Button {
            guard !locked else { return }
            withAnimation(FQAnimations.snappy) {
                game.selectedOption = offset
                game.submitAnswer(for: lessonId, questionIndex: questionIndex, selectedIndex: offset)
            }
        } label: {
            HStack {
                Text(text)
                    .font(FQTheme.rounded(.body, weight: .semibold))
                    .foregroundStyle(FQTheme.ink)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                if showResult && correct {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(FQTheme.primaryGreen)
                        .transition(.scale.combined(with: .opacity))
                } else if showResult && selected && !correct {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(FQTheme.heartRed)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(bg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(border, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(FQOptionButtonStyle())
        .disabled(locked)
    }

    private func explanationCard(q: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(game.answerIsCorrect == true ? "Nice!" : "Let’s learn")
                .font(FQTheme.rounded(.headline, weight: .bold))
                .foregroundStyle(FQTheme.oceanBlue)
            Text(q.explanation)
                .font(FQTheme.rounded(.subheadline, weight: .medium))
                .foregroundStyle(FQTheme.ink.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
        .padding(.bottom, 8)
    }

    private func continueButton(lessonId: String) -> some View {
        Button("Continue") {
            withAnimation(FQAnimations.snappy) {
                game.advanceAfterExplanation(lessonId: lessonId)
            }
        }
        .buttonStyle(FQPrimaryButtonStyle())
        .padding(.top, 4)
    }
}

private struct ShakeEffect: ViewModifier {
    var animates: Bool
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: phase)
            .onChange(of: animates) { _, new in
                guard new else { return }
                withAnimation(.spring(response: 0.12, dampingFraction: 0.2)) {
                    phase = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                    withAnimation(.spring(response: 0.12, dampingFraction: 0.35)) {
                        phase = -8
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    withAnimation(.spring(response: 0.14, dampingFraction: 0.45)) {
                        phase = 0
                    }
                }
            }
    }
}

struct LessonResultView: View {
    @EnvironmentObject private var game: GameViewModel
    let passed: Bool
    let xpEarned: Int

    @State private var showContent = false

    var body: some View {
        ZStack {
            (passed
                ? LinearGradient(colors: [FQTheme.primaryGreen.opacity(0.38), FQTheme.cream], startPoint: .top, endPoint: .bottom)
                : LinearGradient(colors: [FQTheme.heartRed.opacity(0.22), FQTheme.cream], startPoint: .top, endPoint: .bottom)
            )
            .ignoresSafeArea()

            if passed {
                FQConfettiView()
                    .allowsHitTesting(false)
            }

            VStack(spacing: 20) {
                Spacer(minLength: 20)
                EconomistMascotView(mood: passed ? game.mascotMood : .oops, height: passed ? 150 : 120)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)
                    .animation(FQAnimations.bouncy.delay(0.05), value: showContent)

                Image(systemName: passed ? "sparkles" : "heart.slash.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(passed ? FQTheme.gold : FQTheme.heartRed)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.6)
                    .animation(FQAnimations.snappy.delay(0.12), value: showContent)

                Text(passed ? "Lesson complete!" : "Out of hearts")
                    .font(FQTheme.rounded(.largeTitle, weight: .bold))
                    .foregroundStyle(FQTheme.ink)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(FQAnimations.snappy.delay(0.18), value: showContent)

                if passed {
                    Text("+\(xpEarned) XP")
                        .font(FQTheme.rounded(.title2, weight: .bold))
                        .foregroundStyle(FQTheme.deepGreen)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.8)
                        .animation(FQAnimations.bouncy.delay(0.24), value: showContent)
                } else {
                    Text("Review the material and try again—you’ve got this.")
                        .font(FQTheme.rounded(.body, weight: .medium))
                        .foregroundStyle(FQTheme.ink.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .opacity(showContent ? 1 : 0)
                        .animation(FQAnimations.snappy.delay(0.2), value: showContent)
                }
                Spacer()
                Button(passed ? "Keep learning" : "Back to path") {
                    withAnimation(FQAnimations.soft) {
                        game.exitLesson()
                    }
                }
                .buttonStyle(FQPrimaryButtonStyle(color: passed ? FQTheme.primaryGreen : FQTheme.oceanBlue))
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 24)
                .animation(FQAnimations.snappy.delay(0.28), value: showContent)
            }
        }
        .onAppear {
            showContent = true
        }
    }
}

private struct FQConfettiView: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 45.0, paused: false)) { timeline in
            Canvas { context, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let colors = [
                    FQTheme.gold, FQTheme.skyBlue, FQTheme.primaryGreen,
                    FQTheme.lilac, FQTheme.flameOrange
                ]
                let w = max(size.width, 1)
                let h = size.height
                for i in 0..<55 {
                    let x = CGFloat((i * 67 + Int(t * 35)) % Int(w))
                    let speed = 42.0 + Double(i % 19)
                    let y = CGFloat(fmod(t * speed + Double(i * 53), Double(h + 55))) - 28
                    let rw = CGFloat(5 + (i % 3))
                    let rh = CGFloat(7 + (i % 4))
                    let rect = CGRect(x: x, y: y, width: rw, height: rh)
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(colors[i % colors.count].opacity(0.88))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}
