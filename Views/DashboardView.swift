import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @State private var showingAddHobby = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Section
                    welcomeSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Today's Sessions
                    todaySessionsSection
                    
                    // Hobbies List
                    hobbiesSection
                }
                .padding()
            }
            .background(Color.hobbyLabSecondaryBackground)
            .navigationTitle("ArctiLab")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHobby = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.hobbyLabPrimary)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddHobby) {
                AddHobbyView()
            }
        }
    }
    
    private var welcomeSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(viewModel.userProfile.name)!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Ready to practice your hobbies?")
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
            
            Spacer()
            
            Text(viewModel.userProfile.avatarEmoji)
                .font(.system(size: 50))
        }
        .padding()
        .cardStyle()
    }
    
    private var quickStatsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            StatCard(
                title: "Level",
                value: "\(viewModel.userProfile.level)",
                icon: "star.fill",
                color: .hobbyLabPrimary
            )
            
            StatCard(
                title: "Hobbies",
                value: "\(viewModel.hobbies.count)",
                icon: "heart.fill",
                color: Color(hex: "#FF6B9D")
            )
            
            StatCard(
                title: "Total Hours",
                value: String(format: "%.0f", viewModel.getTotalTimeSpent() / 3600),
                icon: "clock.fill",
                color: Color(hex: "#9C27B0")
            )
        }
    }
    
    private var todaySessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Progress")
                .font(.headline)
            
            let todaySessions = getTodaySessions()
            
            if todaySessions.isEmpty {
                Text("No sessions logged today. Start tracking!")
                    .foregroundColor(.hobbyLabSecondaryText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cardStyle()
            } else {
                ForEach(todaySessions, id: \.id) { session in
                    SessionRowView(session: session)
                }
            }
        }
    }
    
    private var hobbiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Hobbies")
                .font(.headline)
            
            if viewModel.hobbies.isEmpty {
                EmptyStateView(
                    icon: "sparkles",
                    title: "No hobbies yet",
                    message: "Tap the + button to add your first hobby!"
                )
            } else {
                ForEach(viewModel.hobbies) { hobby in
                    NavigationLink(destination: HobbyDetailView(hobby: hobby)) {
                        HobbyCardView(hobby: hobby)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private func getTodaySessions() -> [Session] {
        let calendar = Calendar.current
        let today = Date()
        
        var todaySessions: [Session] = []
        for hobby in viewModel.hobbies {
            let sessions = viewModel.getAllSessions(for: hobby.id)
            let filtered = sessions.filter { calendar.isDate($0.date, inSameDayAs: today) }
            todaySessions.append(contentsOf: filtered)
        }
        
        return todaySessions.sorted { $0.date > $1.date }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .fixedSize()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.hobbyLabSecondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardStyle()
    }
}

struct HobbyCardView: View {
    let hobby: Hobby
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: hobby.color).opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: hobby.icon)
                    .font(.title2)
                    .foregroundColor(Color(hex: hobby.color))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(hobby.name)
                    .font(.headline)
                    .foregroundColor(.hobbyLabText)
                
                Text(hobby.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.hobbyLabSecondaryText)
                
                HStack(spacing: 12) {
                    Label("\(hobby.currentStreak) day streak", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Label("\(hobby.projects.count) projects", systemImage: "folder.fill")
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.hobbyLabSecondaryText)
        }
        .padding()
        .cardStyle()
    }
}

struct SessionRowView: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.formattedDuration)
                    .font(.headline)
                
                if !session.notes.isEmpty {
                    Text(session.notes)
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text("+\(session.xpEarned) XP")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.hobbyLabPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.hobbyLabPrimary.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .cardStyle()
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.hobbyLabPrimary.opacity(0.5))
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.hobbyLabSecondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .cardStyle()
    }
}

#Preview {
    DashboardView()
        .environmentObject(HobbyViewModel())
}
