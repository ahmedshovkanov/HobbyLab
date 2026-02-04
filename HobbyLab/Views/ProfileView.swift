import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    profileHeaderSection
                    
                    // Level Progress
                    levelProgressSection
                    
                    // Achievements
                    achievementsSection
                    
                    // Overall Stats
                    statsSection
                }
                .padding()
            }
            .background(Color.hobbyLabSecondaryBackground)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEditProfile = true }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.hobbyLabPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // Avatar
            Text(viewModel.userProfile.avatarEmoji)
                .font(.system(size: 80))
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(Color.hobbyLabPrimary.opacity(0.1))
                )
            
            // Name and Level
            VStack(spacing: 4) {
                Text(viewModel.userProfile.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Level \(viewModel.userProfile.level)")
                        .font(.headline)
                        .foregroundColor(.hobbyLabPrimary)
                }
            }
            
            // Member Since
            Text("Member since \(viewModel.userProfile.joinDate.formatted(style: "medium"))")
                .font(.caption)
                .foregroundColor(.hobbyLabSecondaryText)
        }
        .padding()
        .cardStyle()
    }
    
    private var levelProgressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Level Progress")
                    .font(.headline)
                
                Spacer()
                
                Text("\(viewModel.userProfile.currentXP) / \(viewModel.userProfile.xpForNextLevel) XP")
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.hobbyLabPrimary.opacity(0.2))
                        .frame(height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.hobbyLabPrimary, Color(hex: "#9C27B0")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * viewModel.userProfile.progressToNextLevel, height: 12)
                        .cornerRadius(6)
                        .animation(.spring(), value: viewModel.userProfile.progressToNextLevel)
                }
            }
            .frame(height: 12)
            
            HStack(spacing: 20) {
                StatPill(label: "Total XP", value: "\(viewModel.userProfile.totalXP)")
                StatPill(label: "Achievements", value: "\(viewModel.userProfile.achievements.filter { $0.isUnlocked }.count)")
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: AllAchievementsView()) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.hobbyLabPrimary)
                }
            }
            
            let unlockedAchievements = viewModel.userProfile.achievements.filter { $0.isUnlocked }
            
            if unlockedAchievements.isEmpty {
                EmptyStateView(
                    icon: "trophy.fill",
                    title: "No achievements yet",
                    message: "Keep practicing to unlock achievements!"
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(unlockedAchievements.prefix(5)) { achievement in
                            AchievementBadge(achievement: achievement, size: .medium)
                        }
                    }
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Statistics")
                .font(.headline)
            
            VStack(spacing: 12) {
                IconStatRow(
                    icon: "heart.fill",
                    label: "Total Hobbies",
                    value: "\(viewModel.hobbies.count)",
                    color: Color(hex: "#FF6B9D")
                )
                
                IconStatRow(
                    icon: "folder.fill",
                    label: "Active Projects",
                    value: "\(getTotalProjects())",
                    color: .hobbyLabPrimary
                )
                
                IconStatRow(
                    icon: "checkmark.circle.fill",
                    label: "Completed Tasks",
                    value: "\(getCompletedTasks())",
                    color: Color(hex: "#4CAF50")
                )
                
                IconStatRow(
                    icon: "clock.fill",
                    label: "Total Time",
                    value: formatTotalTime(viewModel.getTotalTimeSpent()),
                    color: Color(hex: "#FF9800")
                )
                
                IconStatRow(
                    icon: "flame.fill",
                    label: "Longest Streak",
                    value: "\(getLongestStreak()) days",
                    color: .orange
                )
            }
        }
        .padding()
        .cardStyle()
    }
    
    // MARK: - Helper Functions
    
    private func getTotalProjects() -> Int {
        viewModel.hobbies.reduce(0) { $0 + $1.projects.count }
    }
    
    private func getCompletedTasks() -> Int {
        var count = 0
        for hobby in viewModel.hobbies {
            for project in hobby.projects {
                count += project.tasks.filter { $0.isCompleted }.count
            }
        }
        return count
    }
    
    private func getLongestStreak() -> Int {
        viewModel.hobbies.map { $0.longestStreak }.max() ?? 0
    }
    
    private func formatTotalTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        return "\(hours)h"
    }
}

// MARK: - Supporting Views

struct StatPill: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(.hobbyLabPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.hobbyLabSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.hobbyLabPrimary.opacity(0.1))
        .cornerRadius(8)
    }
}

struct IconStatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.hobbyLabPrimary)
        }
    }
}

enum AchievementSize {
    case small, medium, large
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 30
        case .medium: return 40
        case .large: return 60
        }
    }
    
    var frameSize: CGFloat {
        switch self {
        case .small: return 60
        case .medium: return 80
        case .large: return 120
        }
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    let size: AchievementSize
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient(
                            colors: [Color.hobbyLabPrimary, Color(hex: "#9C27B0")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size.frameSize, height: size.frameSize)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: size.iconSize))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)
            }
            
            if size != .small {
                VStack(spacing: 2) {
                    Text(achievement.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    if achievement.isUnlocked, let date = achievement.unlockedDate {
                        Text(date.formatted(style: "short"))
                            .font(.system(size: 10))
                            .foregroundColor(.hobbyLabSecondaryText)
                    }
                }
                .frame(width: size.frameSize + 20)
            }
        }
    }
}

struct AllAchievementsView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    
    // Predefined achievements
    let allPossibleAchievements = [
        Achievement(title: "First Steps", description: "Complete your first session", icon: "flag.fill", category: .milestone),
        Achievement(title: "Dedicated", description: "Log sessions for 7 days straight", icon: "flame.fill", category: .consistency),
        Achievement(title: "Diverse Interests", description: "Track 5 different hobbies", icon: "star.fill", category: .variety),
        Achievement(title: "Century Club", description: "Complete 100 sessions", icon: "100.circle.fill", category: .milestone),
        Achievement(title: "Rising Star", description: "Reach level 10", icon: "sparkles", category: .mastery),
        Achievement(title: "Time Master", description: "Log 100 hours total", icon: "clock.fill", category: .mastery),
        Achievement(title: "Task Crusher", description: "Complete 50 tasks", icon: "checkmark.circle.fill", category: .milestone),
        Achievement(title: "Project Pro", description: "Complete 10 projects", icon: "folder.badge.checkmark", category: .milestone),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(AchievementCategory.allCases, id: \.self) { category in
                    achievementCategory(category)
                }
            }
            .padding()
        }
        .background(Color.hobbyLabSecondaryBackground)
        .navigationTitle("All Achievements")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func achievementCategory(_ category: AchievementCategory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.rawValue)
                .font(.headline)
            
            let achievements = allPossibleAchievements.filter { $0.category == category }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(achievements) { achievement in
                    let unlocked = viewModel.userProfile.achievements.first { $0.title == achievement.title }
                    AchievementBadge(
                        achievement: unlocked ?? achievement,
                        size: .medium
                    )
                }
            }
        }
        .padding()
        .cardStyle()
    }
}

struct EditProfileView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var selectedEmoji: String
    
    let emojiOptions = ["🎨", "🎸", "⚽️", "💻", "✍️", "🌱", "🍳", "✂️", "📸", "📚", "🎮", "🏃"]
    
    init() {
        _name = State(initialValue: "")
        _selectedEmoji = State(initialValue: "🎨")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Avatar")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Button(action: { selectedEmoji = emoji }) {
                                Text(emoji)
                                    .font(.system(size: 40))
                                    .frame(width: 50, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedEmoji == emoji ? Color.hobbyLabPrimary.opacity(0.2) : Color.clear)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedEmoji == emoji ? Color.hobbyLabPrimary : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: saveProfile) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.hobbyLabPrimary)
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                name = viewModel.userProfile.name
                selectedEmoji = viewModel.userProfile.avatarEmoji
            }
        }
    }
    
    private func saveProfile() {
        viewModel.userProfile.name = name
        viewModel.userProfile.avatarEmoji = selectedEmoji
        dismiss()
    }
}

#Preview {
    ProfileView()
        .environmentObject(HobbyViewModel())
}
