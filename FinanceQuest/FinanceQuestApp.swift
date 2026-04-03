import SwiftUI

@main
struct FinanceQuestApp: App {
    @StateObject private var game = GameViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(game)
        }
    }
}
