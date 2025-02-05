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

class PickerStates: ObservableObject {
    @Published var isVisible = false
    @Published var sleepEntry = SleepEntry() {
        didSet {
            tempDatetime = sleepEntry.datetime
        }
    }
    @Published var tempDatetime = Date()

    func reset() {
        sleepEntry = SleepEntry()
    }

    func toggle() {
        withAnimation(.easeInOut(duration: 0.20)) {
            isVisible.toggle()
            if isVisible == false {
                reset()
            }
        }
    }
}

struct ContentView: View {
    @StateObject var picker = PickerStates()
    @Environment(\.modelContext) private var store
    @Query private var sleepEntries: [SleepEntry]
    
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
                        ForEach(sortedEntries) {
                            SleepEntryView(sleepEntry: $0, picker: picker)
                        }
                    }
                }
            }
        
            VStack {
                if sleepEntries.isEmpty && !picker.isVisible {
                    Buttons.AddFirstEntry() {
                        picker.toggle()
                    }
                }
                else if !picker.isVisible {
                    HStack {
                        Buttons.Plus() {
                            picker.toggle()
                        }
                    switch sleepEntries.last!.type {
                    case .wentToSleep:
                        Buttons.WakeUp() {
                            let sleepEntry = SleepEntry(type: .wokeUp)
                            store.insert(sleepEntry)
                        }
                    case .wokeUp:
                        Buttons.GoToSleep() {
                            let sleepEntry = SleepEntry(type: .wentToSleep)
                            store.insert(sleepEntry)
                        }
                    }
                    }
                }
            }
            .padding(.bottom, 40)
            .transition(.move(edge: .bottom))
            if picker.isVisible {
                VStack {
                    HStack {
                        Buttons.Cancel() {
                            picker.toggle()
                        }
                        
                        if picker.sleepEntry.isJustCreated {
                            Buttons.AddFirstEntry(text: "Add") {
                                store.insert(picker.sleepEntry)
                                picker.toggle()
                            }
                        }
                        
                        else {
                            Buttons.Confirm() {
                                picker.sleepEntry.datetime = picker.tempDatetime
                                do {
                                    try store.save()
                                }
                                catch let error {
                                    print(error.localizedDescription)
                                }
                                picker.toggle()
                            }
                        }
                    }
                    WheelDatePickerView(selectedDate: $picker.tempDatetime)
                    
                    Picker("", selection: $picker.sleepEntry.type) {
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
