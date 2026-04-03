import Combine
import Foundation
import SwiftUI

enum LessonPhase: Equatable {
    case idle
    case active(lessonId: String, index: Int, hearts: Int)
    case result(lessonId: String, passed: Bool, xpEarned: Int)
}

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var progress: UserProgress
    @Published var phase: LessonPhase = .idle
    @Published var showExplanation: Bool = false
    @Published var selectedOption: Int?
    @Published var answerIsCorrect: Bool?
    @Published var shakeWrong: Bool = false
    @Published var mascotMood: MascotMood = .idle

    private let baseXPLesson = 12

    init(progress: UserProgress? = nil) {
        self.progress = progress ?? ProgressStore.load()
    }

    func startLesson(_ lessonId: String) {
        guard Curriculum.lesson(byId: lessonId) != nil else { return }
        phase = .active(lessonId: lessonId, index: 0, hearts: 3)
        mascotMood = .curious
        resetQuestionUI()
    }

    func submitAnswer(for lessonId: String, questionIndex: Int, selectedIndex: Int) {
        guard let lesson = Curriculum.lesson(byId: lessonId),
              questionIndex < lesson.questions.count else { return }
        let q = lesson.questions[questionIndex]
        let correct = selectedIndex == q.correctIndex
        answerIsCorrect = correct
        showExplanation = true
        mascotMood = correct ? .delighted : .oops
        if !correct {
            shakeWrong = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.shakeWrong = false
            }
            if case .active(let id, let idx, let h) = phase, id == lessonId {
                let newHearts = max(0, h - 1)
                phase = .active(lessonId: lessonId, index: idx, hearts: newHearts)
            }
        }
    }

    func advanceAfterExplanation(lessonId: String) {
        guard let lesson = Curriculum.lesson(byId: lessonId) else { return }
        guard case .active(let id, let index, let hearts) = phase, id == lessonId else { return }
        resetQuestionUI()
        if hearts <= 0 {
            mascotMood = .oops
            phase = .result(lessonId: lessonId, passed: false, xpEarned: 0)
            return
        }
        let next = index + 1
        if next >= lesson.questions.count {
            let xp = baseXPLesson + lesson.questions.count * 3
            var p = progress
            p.recordLessonComplete(lessonId: lessonId, baseXP: xp)
            progress = p
            ProgressStore.save(p)
            phase = .result(lessonId: lessonId, passed: true, xpEarned: xp)
            mascotMood = .cheering
        } else {
            phase = .active(lessonId: lessonId, index: next, hearts: hearts)
            mascotMood = .curious
        }
    }

    func exitLesson() {
        phase = .idle
        mascotMood = .idle
        resetQuestionUI()
    }

    func resetQuestionUI() {
        showExplanation = false
        selectedOption = nil
        answerIsCorrect = nil
    }

    func isLessonComplete(_ id: String) -> Bool {
        progress.completedLessonIds.contains(id)
    }

    func completionRatio(for unit: Unit) -> Double {
        let total = Double(unit.lessons.count)
        guard total > 0 else { return 0 }
        let done = Double(unit.lessons.filter { progress.completedLessonIds.contains($0.id) }.count)
        return done / total
    }
}
