import SwiftUI

struct HobbyDetailView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    let hobby: Hobby
    
    @State private var showingAddProject = false
    @State private var showingIdeasBank = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection
                
                // Quick Actions
                quickActionsSection
                
                // Progress Overview
                progressSection
                
                // Projects
                projectsSection
                
                // Recent Sessions
                recentSessionsSection
            }
            .padding()
        }
        .background(Color.hobbyLabSecondaryBackground)
        .navigationTitle(hobby.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingAddProject) {
            AddProjectView(hobbyId: hobby.id)
        }
        .sheet(isPresented: $showingIdeasBank) {
            IdeaBankView(hobbyId: hobby.id)
        }
    }
    
    private var headerSection: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(hex: hobby.color).opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: hobby.icon)
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: hobby.color))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(hobby.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.hobbyLabSecondaryText)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(hobby.currentStreak) day streak")
                        .font(.headline)
                }
                
                Text("Total: \(formatTime(hobby.totalTimeSpent))")
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
            
            Spacer()
        }
        .padding()
        .cardStyle()
    }
    
    private var quickActionsSection: some View {
        ActionButton(
            title: "Ideas",
            icon: "lightbulb.fill",
            color: Color(hex: "#FFC107")
        ) {
            showingIdeasBank = true
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress Overview")
                .font(.headline)
            
            let completedProjects = hobby.projects.filter { $0.isCompleted }.count
            let totalProjects = hobby.projects.count
            
            HStack(spacing: 20) {
                VStack {
                    ZStack {
                        ProgressRing(
                            progress: totalProjects > 0 ? Double(completedProjects) / Double(totalProjects) : 0,
                            lineWidth: 10,
                            color: Color(hex: hobby.color)
                        )
                        .frame(width: 80, height: 80)
                        
                        Text("\(completedProjects)/\(totalProjects)")
                            .font(.headline)
                    }
                    
                    Text("Projects Done")
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    StatRow(label: "Active Projects", value: "\(totalProjects - completedProjects)")
                    StatRow(label: "Total Sessions", value: "\(getTotalSessions())")
                    StatRow(label: "Longest Streak", value: "\(hobby.longestStreak) days")
                }
                
                Spacer()
            }
            .padding()
            .cardStyle()
        }
    }
    
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Projects")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showingAddProject = true }) {
                    Label("New", systemImage: "plus")
                        .font(.subheadline)
                        .foregroundColor(.hobbyLabPrimary)
                }
            }
            
            if hobby.projects.isEmpty {
                EmptyStateView(
                    icon: "folder.fill",
                    title: "No projects yet",
                    message: "Create a project to organize your work"
                )
            } else {
                ForEach(hobby.projects) { project in
                    NavigationLink(destination: ProjectDetailView(hobbyId: hobby.id, project: project)) {
                        ProjectCardView(project: project, hobbyColor: hobby.color)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.headline)
            
            let sessions = viewModel.getAllSessions(for: hobby.id)
                .sorted { $0.date > $1.date }
                .prefix(5)
            
            if sessions.isEmpty {
                Text("No sessions yet. Start tracking!")
                    .foregroundColor(.hobbyLabSecondaryText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cardStyle()
            } else {
                ForEach(Array(sessions)) { session in
                    SessionDetailRow(session: session)
                }
            }
        }
    }
    
    private func getTotalSessions() -> Int {
        viewModel.getAllSessions(for: hobby.id).count
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        return "\(hours)h"
    }
}

// MARK: - Supporting Views

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.hobbyLabSecondaryText)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct ProjectCardView: View {
    let project: Project
    let hobbyColor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(project.name)
                    .font(.headline)
                    .foregroundColor(.hobbyLabText)
                
                Spacer()
                
                if project.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.hobbyLabSuccess)
                }
            }
            
            if !project.description.isEmpty {
                Text(project.description)
                    .font(.caption)
                    .foregroundColor(.hobbyLabSecondaryText)
                    .lineLimit(2)
            }
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(Int(project.progress * 100))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: hobbyColor))
                    
                    Spacer()
                    
                    Text("\(project.completedTasksCount)/\(project.tasks.count) tasks")
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(hex: hobbyColor).opacity(0.2))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        Rectangle()
                            .fill(Color(hex: hobbyColor))
                            .frame(width: geometry.size.width * project.progress, height: 6)
                            .cornerRadius(3)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding()
        .cardStyle()
    }
}

struct SessionDetailRow: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.date.formatted(style: "medium"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if !session.notes.isEmpty {
                    Text(session.notes)
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                        .lineLimit(2)
                }
                
                if !session.tags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(session.tags.prefix(3), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .foregroundColor(.hobbyLabPrimary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.hobbyLabPrimary.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(session.formattedDuration)
                    .font(.headline)
                    .foregroundColor(.hobbyLabPrimary)
                
                Text("+\(session.xpEarned) XP")
                    .font(.caption)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    NavigationView {
        HobbyDetailView(hobby: Hobby(name: "Painting", category: .art))
            .environmentObject(HobbyViewModel())
    }
}
