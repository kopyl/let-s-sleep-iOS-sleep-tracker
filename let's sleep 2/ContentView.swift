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
    
    var tempEntry = SleepEntry()
    @Published var sleepEntry = SleepEntry() {
        didSet {
            tempEntry.datetime = sleepEntry.datetime
            tempEntry.type = sleepEntry.type
        }
    }

    func reset() {
        sleepEntry = SleepEntry()
    }
    
    func saveChanges(to store: ModelContext) {
        sleepEntry.datetime = tempEntry.datetime
        sleepEntry.type = tempEntry.type
        store.insert(sleepEntry)
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
    
    func groupedEntriesByDay() -> [Date: [SleepEntry]] {
        return Dictionary(grouping: sleepEntries) { entry in
            Calendar.current.startOfDay(for: entry.datetime)
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(groupedEntriesByDay().sorted(by: { $0.key < $1.key }), id: \.key) { date, entries in
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
                            store.saveWakeUp()
                        }
                    case .wokeUp:
                        Buttons.GoToSleep() {
                            store.saveGoToSleep()
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
                                picker.saveChanges(to: store)
                                picker.toggle()
                            }
                        }
                        
                        else {
                            Buttons.Confirm() {
                                picker.saveChanges(to: store)
                                picker.toggle()
                            }
                        }
                    }
                    WheelDatePickerView(selectedDate: $picker.tempEntry.datetime)
                    
                    Picker("", selection: $picker.tempEntry.type) {
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

    return ContentView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
