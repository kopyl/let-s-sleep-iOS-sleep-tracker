import SwiftUI
import SwiftData

@main
struct let_s_sleep_2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [SleepEntry.self])
        }
    }
}
