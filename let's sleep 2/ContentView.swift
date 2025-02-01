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
    
    @State private var timePickerVisible = false
    @Environment(\.modelContext) private var store
    @Query private var sleepEntries: [SleepEntry]
    
    func toggleDateTimePicker() {
        withAnimation(.linear(duration: 0.2)) {
            timePickerVisible.toggle()
            currentDatePickerDateTime = Date()
            currentSleepManualEntryType = .wentToSleep
        }
    }
    
    func deleteSleepEntries(at offsets: IndexSet) {
        for index in offsets {
            let sleepEntry = sleepEntries[index]
            store.delete(sleepEntry)
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(sleepEntries, id: \.self) { sleepEntry in
                    HStack {
                        Text(formattedDate(sleepEntry.datetime))
                        Text(formattedTime(sleepEntry.datetime))
                        Spacer()
                        Text(sleepEntry.type.rawValue)
                    }
                }
                .onDelete(perform: deleteSleepEntries)
            }
        
            if !timePickerVisible {
                Buttons.AddFirstEntry() {
                    toggleDateTimePicker()
                }
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom))
            }
            if timePickerVisible {
                VStack {
                    HStack {
                        Buttons.Cancel() {
                            toggleDateTimePicker()
                        }
                        Buttons.AddFirstEntry(text: "Add") {
                            let sleepEntry = SleepEntry(datetime: currentDatePickerDateTime, type: currentSleepManualEntryType)
                            store.insert(sleepEntry)
                            toggleDateTimePicker()
                        }
                    }
                    WheelDatePickerView(selectedDate: $currentDatePickerDateTime)
                    Picker("Flavor", selection: $currentSleepManualEntryType) {
                        ForEach(SleepManualEntryType.allCases) { flavor in
                            Text(flavor.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
