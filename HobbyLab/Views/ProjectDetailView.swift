import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    let hobbyId: UUID
    let project: Project
    
    @State private var showingAddTask = false
    @State private var showingAddSession = false
    
    var currentProject: Project {
        if let hobby = viewModel.hobbies.first(where: { $0.id == hobbyId }),
           let proj = hobby.projects.first(where: { $0.id == project.id }) {
            return proj
        }
        return project
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Progress Section
                progressSection
                
                // Quick Actions
                actionButtons
                
                // Tasks Section
                tasksSection
                
                // Sessions Section
                sessionsSection
            }
            .padding()
        }
        .background(Color.hobbyLabSecondaryBackground)
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(hobbyId: hobbyId, projectId: project.id)
        }
        .sheet(isPresented: $showingAddSession) {
            AddSessionView(hobbyId: hobbyId, projectId: project.id)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 16) {
            if !currentProject.description.isEmpty {
                Text(currentProject.description)
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 30) {
                VStack {
                    ZStack {
                        ProgressRing(progress: currentProject.progress, lineWidth: 12)
                            .frame(width: 100, height: 100)
                        
                        VStack(spacing: 2) {
                            Text("\(Int(currentProject.progress * 100))%")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Complete")
                                .font(.caption)
                                .foregroundColor(.hobbyLabSecondaryText)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(
                        icon: "checkmark.circle.fill",
                        label: "Tasks",
                        value: "\(currentProject.completedTasksCount)/\(currentProject.tasks.count)"
                    )
                    
                    InfoRow(
                        icon: "clock.fill",
                        label: "Time Spent",
                        value: formatTime(currentProject.totalTimeSpent)
                    )
                    
                    if let targetDate = currentProject.targetEndDate {
                        InfoRow(
                            icon: "calendar",
                            label: "Due Date",
                            value: targetDate.formatted(style: "short")
                        )
                    }
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: { showingAddSession = true }) {
                Label("Log Session", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button(action: { showingAddTask = true }) {
                Label("Add Task", systemImage: "checklist")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tasks")
                .font(.headline)
            
            if currentProject.tasks.isEmpty {
                EmptyStateView(
                    icon: "checklist",
                    title: "No tasks yet",
                    message: "Add tasks to track your progress"
                )
            } else {
                ForEach(currentProject.tasks) { task in
                    TaskRow(task: task, hobbyId: hobbyId, projectId: project.id)
                }
            }
        }
    }
    
    private var sessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sessions")
                .font(.headline)
            
            if currentProject.sessions.isEmpty {
                Text("No sessions logged yet")
                    .foregroundColor(.hobbyLabSecondaryText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cardStyle()
            } else {
                ForEach(currentProject.sessions.sorted { $0.date > $1.date }) { session in
                    SessionDetailRow(session: session)
                }
            }
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.hobbyLabPrimary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.hobbyLabSecondaryText)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct TaskRow: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    let task: ProjectTask
    let hobbyId: UUID
    let projectId: UUID
    
    var body: some View {
        Button(action: {
            viewModel.toggleTask(task, in: projectId, hobbyId: hobbyId)
        }) {
            HStack(spacing: 12) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(task.isCompleted ? .hobbyLabSuccess : .hobbyLabSecondaryText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.subheadline)
                        .foregroundColor(.hobbyLabText)
                        .strikethrough(task.isCompleted)
                    
                    if !task.description.isEmpty {
                        Text(task.description)
                            .font(.caption)
                            .foregroundColor(.hobbyLabSecondaryText)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Circle()
                    .fill(Color(hex: task.priority.color))
                    .frame(width: 8, height: 8)
            }
            .padding()
            .background(Color.hobbyLabCard)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        ProjectDetailView(
            hobbyId: UUID(),
            project: Project(hobbyId: UUID(), name: "Learn SwiftUI", description: "Master SwiftUI basics")
        )
        .environmentObject(HobbyViewModel())
    }
}
