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
            pickerStates.sleepEntry = sleepEntry
            pickerStates.sleepEntry.isJustCreated = false
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
