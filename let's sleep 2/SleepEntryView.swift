import SwiftUI

struct SleepEntryView: View {
    @Bindable var sleepEntry: SleepEntry
    @Environment(\.modelContext) private var store
    @ObservedObject var picker: PickerStates

    var body: some View {
        HStack {
            Icons.sleepEvent(type: sleepEntry.type)
            Text(sleepEntry.type.rawValue)
            Spacer()
            Text(formattedTime(sleepEntry.datetime))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            picker.sleepEntry = sleepEntry
            picker.sleepEntry.isJustCreated = false
            picker.toggle()
        }
        .swipeActions(edge: .trailing) {
            Button("", systemImage: "trash") {
                store.delete(sleepEntry)
                picker.isVisible = false
            }
            .tint(.red)
        }
    }
}
