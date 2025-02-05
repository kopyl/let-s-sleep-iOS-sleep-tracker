import SwiftUI

struct SleepEntryView: View {
    @Bindable var sleepEntry: SleepEntry
    @Environment(\.modelContext) private var store
    @ObservedObject var pickerStates: PickerStates

    var body: some View {
        HStack {
            Icons.sleepEvent(type: sleepEntry.type)
            Text(sleepEntry.type.rawValue)
            Spacer()
            Text(formattedTime(sleepEntry.datetime))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            pickerStates.datetime = sleepEntry.datetime
            pickerStates.sleepManualEntryType = sleepEntry.type
            pickerStates.sleepEntry = sleepEntry
            pickerStates.toggle()
        }
        .swipeActions(edge: .trailing) {
            Button("", systemImage: "trash") {
                store.delete(sleepEntry)
            }
            .tint(.red)
        }
    }
}
