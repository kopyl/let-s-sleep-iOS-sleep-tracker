import Foundation
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

extension ModelContext {
    func saveWakeUp() {
        let sleepEntry = SleepEntry(type: .wokeUp)
        self.insert(sleepEntry)
    }
    
    func saveGoToSleep() {
        let sleepEntry = SleepEntry(type: .wentToSleep)
        self.insert(sleepEntry)
    }
}
