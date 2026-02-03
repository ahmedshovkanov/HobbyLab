import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    let hobbyId: UUID
    let projectId: UUID
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: TaskPriority = .medium
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                    
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(Color(hex: priority.color))
                                    .frame(width: 12, height: 12)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button(action: addTask) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.hobbyLabPrimary)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let task = ProjectTask(
            projectId: projectId,
            title: title,
            description: description,
            priority: priority
        )
        viewModel.addTask(task, to: projectId, in: hobbyId)
        dismiss()
    }
}

#Preview {
    AddTaskView(hobbyId: UUID(), projectId: UUID())
        .environmentObject(HobbyViewModel())
}
