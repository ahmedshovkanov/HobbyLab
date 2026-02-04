import SwiftUI

struct AddSessionView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Binding var isPresented: Bool
    
    let hobbyId: UUID
    var projectId: UUID?
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 30
    @State private var notes = ""
    @State private var tags = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        Form {
                Section(header: Text("Duration")) {
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        
                        Picker("Minutes", selection: $minutes) {
                            ForEach([0, 15, 30, 45], id: \.self) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Section(header: Text("Details")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                    
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                    
                    TextField("Tags (comma separated)", text: $tags)
                }
                
                Section(header: Text("XP Preview")) {
                    HStack {
                        Text("You'll earn:")
                            .foregroundColor(.hobbyLabSecondaryText)
                        
                        Spacer()
                        
                        Text("+\(calculateXP()) XP")
                            .font(.headline)
                            .foregroundColor(.hobbyLabPrimary)
                    }
                }
                
                Section {
                    Button(action: logSession) {
                        Text("Log Session")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.hobbyLabPrimary)
                    .disabled(hours == 0 && minutes == 0)
                }
        }
        .navigationTitle("Log Session")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    isPresented = false
                }
            }
        }
    }
    
    private func calculateXP() -> Int {
        let duration = TimeInterval((hours * 3600) + (minutes * 60))
        return Session.calculateXP(for: duration)
    }
    
    private func logSession() {
        let duration = TimeInterval((hours * 3600) + (minutes * 60))
        let tagArray = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        var session = Session(
            hobbyId: hobbyId,
            projectId: projectId,
            duration: duration,
            notes: notes,
            tags: tagArray
        )
        session.date = selectedDate
        
        viewModel.addSession(session, to: hobbyId, projectId: projectId)
        isPresented = false
    }
}

#Preview {
    AddSessionView(isPresented: .constant(true), hobbyId: UUID())
        .environmentObject(HobbyViewModel())
}
