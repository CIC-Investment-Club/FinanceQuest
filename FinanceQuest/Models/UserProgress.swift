import Foundation

struct UserProgress: Codable, Equatable {
    var xp: Int
    var gems: Int
    var streak: Int
    var lastPracticeDay: String?
    var completedLessonIds: Set<String>

    static let storageKey = "financequest.progress.v1"

    static let `default` = UserProgress(
        xp: 0,
        gems: 50,
        streak: 0,
        lastPracticeDay: nil,
        completedLessonIds: []
    )

    var level: Int {
        max(1, xp / 100 + 1)
    }

    var xpIntoLevel: Int {
        xp % 100
    }

    mutating func recordLessonComplete(lessonId: String, baseXP: Int) {
        if !completedLessonIds.contains(lessonId) {
            completedLessonIds.insert(lessonId)
            xp += baseXP
            gems += 5
        }
        bumpStreakIfNeeded()
    }

    mutating func bumpStreakIfNeeded() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let formatter = Self.dayFormatter
        let todayKey = formatter.string(from: today)

        guard let last = lastPracticeDay else {
            lastPracticeDay = todayKey
            streak = 1
            return
        }

        if last == todayKey { return }

        if let lastDate = formatter.date(from: last) {
            let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
            if cal.isDate(lastDate, inSameDayAs: yesterday) {
                streak += 1
            } else if !cal.isDate(lastDate, inSameDayAs: today) {
                streak = 1
            }
        } else {
            streak = 1
        }
        lastPracticeDay = todayKey
    }

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

enum ProgressStore {
    static func load() -> UserProgress {
        guard let data = UserDefaults.standard.data(forKey: UserProgress.storageKey),
              let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return .default
        }
        return decoded
    }

    static func save(_ progress: UserProgress) {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: UserProgress.storageKey)
        }
    }
}
