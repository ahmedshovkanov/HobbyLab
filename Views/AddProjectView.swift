import SwiftUI

struct AddProjectView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    let hobbyId: UUID
    
    @State private var name = ""
    @State private var description = ""
    @State private var hasDeadline = false
    @State private var targetDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Timeline")) {
                    Toggle("Set Deadline", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                    }
                }
                
                Section {
                    Button(action: addProject) {
                        Text("Create Project")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.hobbyLabPrimary)
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("New Project")
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
    
    private func addProject() {
        let project = Project(
            hobbyId: hobbyId,
            name: name,
            description: description,
            targetEndDate: hasDeadline ? targetDate : nil
        )
        viewModel.addProject(to: hobbyId, project: project)
        dismiss()
    }
}

#Preview {
    AddProjectView(hobbyId: UUID())
        .environmentObject(HobbyViewModel())
}
