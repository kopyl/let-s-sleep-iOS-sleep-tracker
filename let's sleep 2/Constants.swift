import SwiftUI

enum IconNames: String {
    case plus = "plus.square.fill"
    case sun = "sunrise.fill"
    case bed = "bed.double.fill"
    case confirm = "checkmark.square.fill"
}

enum ColorHex: UInt {
    case yellow = 0xE5DC6A
    case blue = 0x459EFF
    case grey = 0xF0F7FF
}

struct _Color {
    static let yellow = Color(hex: ColorHex.yellow.rawValue)
    static let blue = Color(hex: ColorHex.blue.rawValue)
}

enum buttonsCopy: String {
    case addFirstEntry = "Add first entry"
    case goToSleep = "Go to sleep"
    case wakeUp = "Wake up"
    case confirm = "Confirm"
    case cancel = "Cancel"
}

enum SleepStatus {
    case awake
    case asleep
}

enum SleepManualEntryType: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    
    case wentToSleep = "Went to sleep"
    case wokeUp = "Woke up"
}
