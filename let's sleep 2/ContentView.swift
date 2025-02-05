import SwiftUI
import SwiftData

func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

struct WheelDatePickerView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: [.hourAndMinute, .date])
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
    }
}

struct ContentView: View {
    @State var currentDatePickerDateTime = Date()
    @State var currentSleepManualEntryType: SleepManualEntryType = .wentToSleep
    @State var currentSelectedSleepEntry: SleepEntry?
    
    @State private var timePickerVisible = false
    @Environment(\.modelContext) private var store
    @Query private var sleepEntries: [SleepEntry]
    
    func toggleDateTimePicker() {
        withAnimation(.easeInOut(duration: 0.20)) {
            timePickerVisible.toggle()
        }
    }
    
    func resetDateTimePicker() {
        currentDatePickerDateTime = Date()
        currentSleepManualEntryType = .wentToSleep
    }
    
    func groupedEntries() -> [String: [SleepEntry]] {
        let res = Dictionary(grouping: sleepEntries.sorted(by: { $0.datetime > $1.datetime })) { entry in
            String(Int(entry.datetime.timeIntervalSince1970/86400))
        }
        return res
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(groupedEntries().sorted(by: { $0.key < $1.key }), id: \.key) { date, entries in
                    let title = formattedDate(entries.first?.datetime ?? Date())
                    let sortedEntries = entries.sorted(by: {$0.datetime < $1.datetime})
                    
                    Section(header: Text(title)) {
                        ForEach(sortedEntries, id: \.self) { sleepEntry in
                            HStack {
                                Icons.sleepEvent(type: sleepEntry.type)
                                Text(sleepEntry.type.rawValue)
                                Spacer()
                                Text(formattedTime(sleepEntry.datetime))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentDatePickerDateTime = sleepEntry.datetime
                                currentSleepManualEntryType = sleepEntry.type
                                currentSelectedSleepEntry = sleepEntry
                                toggleDateTimePicker()
                            }
                            .onLongPressGesture {
                                try? store.delete(model: SleepEntry.self)
                            }
                        }
                        .onDelete(perform: { offsets in
                            for offset in offsets {
                                store.delete(sortedEntries[offset])
                            }
                        })
                    }
                }
            }
        
            VStack {
                if sleepEntries.isEmpty {
                    if !timePickerVisible {
                        Buttons.AddFirstEntry() {
                            resetDateTimePicker()
                            toggleDateTimePicker()
                        }
                    }
                } else {
                    if !timePickerVisible {
                        if let type = sleepEntries.last?.type {
                            switch type {
                            case .wentToSleep:
                                HStack {
                                    Buttons.Plus() {
                                        resetDateTimePicker()
                                        toggleDateTimePicker()
                                    }
                                    Buttons.WakeUp() {
                                        let sleepEntry = SleepEntry(datetime: Date(), type: .wokeUp)
                                        store.insert(sleepEntry)
                                    }
                                }
                            case .wokeUp:
                                HStack {
                                    Buttons.Plus() {
                                        resetDateTimePicker()
                                        toggleDateTimePicker()
                                    }
                                    Buttons.GoToSleep() {
                                        let sleepEntry = SleepEntry(datetime: Date(), type: .wentToSleep)
                                        store.insert(sleepEntry)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 40)
            .transition(.move(edge: .bottom))
            if timePickerVisible {
                VStack {
                    HStack {
                        Buttons.Cancel() {
                            toggleDateTimePicker()
                            
                        }
                        if currentSelectedSleepEntry != nil {
                            Buttons.AddFirstEntry(text: "Done") {
                                currentSelectedSleepEntry?.datetime = currentDatePickerDateTime
                                currentSelectedSleepEntry?.type = currentSleepManualEntryType
                                do {
                                    try store.save()
                                }
                                catch let error {
                                    print(error.localizedDescription)
                                }
                                toggleDateTimePicker()
                                currentSelectedSleepEntry = nil
                            }
                        }
                        else {
                            Buttons.AddFirstEntry(text: "Add") {
                                let sleepEntry = SleepEntry(datetime: currentDatePickerDateTime, type: currentSleepManualEntryType)
                                store.insert(sleepEntry)
                                toggleDateTimePicker()
                            }
                        }
                    }
                    WheelDatePickerView(selectedDate: $currentDatePickerDateTime)
                    Picker("", selection: $currentSleepManualEntryType) {
                        ForEach(SleepManualEntryType.allCases) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .clipped()
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .padding(.top)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SleepEntry.self, configurations: config)
    
    let context = container.mainContext
    context.insert(
        SleepEntry(datetime: Date(timeIntervalSince1970: 1738224074), type: .wokeUp)
    )
    context.insert(
        SleepEntry(datetime: Date(timeIntervalSince1970: 1738324074), type: .wokeUp)
    )
    context.insert(
        SleepEntry(datetime: Date(timeIntervalSince1970: 1738424074), type: .wokeUp)
    )
    context.insert(
        SleepEntry(datetime: Date(timeIntervalSince1970: 1738434074), type: .wokeUp)
    )
    context.insert(
        SleepEntry(datetime: Date(timeIntervalSince1970: 1738444074), type: .wokeUp)
    )

    
    return ContentView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
