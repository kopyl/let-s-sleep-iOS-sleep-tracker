import SwiftUI
import SwiftData

@Model
class SleepEntry {
    @Attribute(.unique) var id: UUID = UUID()
    var datetime = Date()
    var type = SleepManualEntryType.wentToSleep
    var isJustCreated = true
    
    init() {}
    
    init(type: SleepManualEntryType) {
        self.datetime = Date()
        self.type = type
    }

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
