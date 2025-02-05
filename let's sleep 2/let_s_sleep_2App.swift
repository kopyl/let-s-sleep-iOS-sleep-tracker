import SwiftUI
import SwiftData

@Model
class SleepEntry {
    @Attribute(.unique) var id: UUID = UUID()
    var datetime: Date
    var type: SleepManualEntryType
    var isJustCreated = true

    init(datetime: Date, type: SleepManualEntryType) {
        self.datetime = datetime
        self.type = type
    }
}

@main
struct let_s_sleep_2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [SleepEntry.self])
        }
    }
}
