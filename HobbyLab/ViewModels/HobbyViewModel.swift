import Foundation
import SwiftUI
import Combine

class HobbyViewModel: ObservableObject {
    @Published var hobbies: [Hobby] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var userProfile: UserProfile {
        didSet {
            saveData()
        }
    }
    
    private let persistence = PersistenceManager.shared
    
    init() {
        // Load saved data or create default profile
        if let savedProfile = persistence.loadUserProfile() {
            self.userProfile = savedProfile
        } else {
            self.userProfile = UserProfile(name: "Hobbyist", avatarEmoji: "🎨")
        }
        
        // Load saved hobbies
        self.hobbies = persistence.loadHobbies()
    }
    
    // MARK: - Persistence
    
    private func saveData() {
        persistence.saveHobbies(hobbies)
        persistence.saveUserProfile(userProfile)
    }
    
    // MARK: - Hobby Management
    
    func addHobby(_ hobby: Hobby) {
        hobbies.append(hobby)
        checkAchievements()
    }
    
    func deleteHobby(_ hobby: Hobby) {
        hobbies.removeAll { $0.id == hobby.id }
    }
    
    func updateHobby(_ hobby: Hobby) {
        if let index = hobbies.firstIndex(where: { $0.id == hobby.id }) {
            hobbies[index] = hobby
        }
    }
    
    // MARK: - Project Management
    
    func addProject(to hobbyId: UUID, project: Project) {
        if let index = hobbies.firstIndex(where: { $0.id == hobbyId }) {
            hobbies[index].projects.append(project)
        }
    }
    
    func updateProject(_ project: Project, in hobbyId: UUID) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }),
           let projectIndex = hobbies[hobbyIndex].projects.firstIndex(where: { $0.id == project.id }) {
            hobbies[hobbyIndex].projects[projectIndex] = project
        }
    }
    
    func deleteProject(_ project: Project, from hobbyId: UUID) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }) {
            hobbies[hobbyIndex].projects.removeAll { $0.id == project.id }
        }
    }
    
    // MARK: - Session Management
    
    func addSession(_ session: Session, to hobbyId: UUID, projectId: UUID? = nil) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }) {
            hobbies[hobbyIndex].totalTimeSpent += session.duration
            
            // Update streak
            updateStreak(for: hobbyId)
            
            if let projectId = projectId,
               let projectIndex = hobbies[hobbyIndex].projects.firstIndex(where: { $0.id == projectId }) {
                hobbies[hobbyIndex].projects[projectIndex].sessions.append(session)
            }
            
            // Add XP to user
            userProfile.addXP(session.xpEarned)
            checkAchievements()
        }
    }
    
    func updateStreak(for hobbyId: UUID) {
        guard let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }) else { return }
        
        let allSessions = getAllSessions(for: hobbyId)
        guard !allSessions.isEmpty else { return }
        
        let sortedSessions = allSessions.sorted { $0.date > $1.date }
        let calendar = Calendar.current
        
        var streak = 0
        var lastDate = Date()
        
        for session in sortedSessions {
            let daysDiff = calendar.dateComponents([.day], from: session.date.startOfDay(), to: lastDate.startOfDay()).day ?? 0
            
            if daysDiff <= 1 {
                streak += 1
                lastDate = session.date
            } else {
                break
            }
        }
        
        hobbies[hobbyIndex].currentStreak = streak
        if streak > hobbies[hobbyIndex].longestStreak {
            hobbies[hobbyIndex].longestStreak = streak
        }
    }
    
    func getAllSessions(for hobbyId: UUID) -> [Session] {
        guard let hobby = hobbies.first(where: { $0.id == hobbyId }) else { return [] }
        
        var sessions: [Session] = []
        for project in hobby.projects {
            sessions.append(contentsOf: project.sessions)
        }
        return sessions
    }
    
    func addTask(_ task: ProjectTask, to projectId: UUID, in hobbyId: UUID) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }),
           let projectIndex = hobbies[hobbyIndex].projects.firstIndex(where: { $0.id == projectId }) {
            hobbies[hobbyIndex].projects[projectIndex].tasks.append(task)
            hobbies[hobbyIndex].projects[projectIndex].updateProgress()
        }
    }
    
    func toggleTask(_ task: ProjectTask, in projectId: UUID, hobbyId: UUID) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }),
           let projectIndex = hobbies[hobbyIndex].projects.firstIndex(where: { $0.id == projectId }),
           let taskIndex = hobbies[hobbyIndex].projects[projectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            hobbies[hobbyIndex].projects[projectIndex].tasks[taskIndex].isCompleted.toggle()
            
            if hobbies[hobbyIndex].projects[projectIndex].tasks[taskIndex].isCompleted {
                hobbies[hobbyIndex].projects[projectIndex].tasks[taskIndex].completedDate = Date()
                userProfile.addXP(5) // Bonus XP for completing a task
            } else {
                hobbies[hobbyIndex].projects[projectIndex].tasks[taskIndex].completedDate = nil
            }
            
            hobbies[hobbyIndex].projects[projectIndex].updateProgress()
            checkAchievements()
        }
    }
    
    // MARK: - Idea Management
    
    func addIdea(_ idea: Idea, to hobbyId: UUID) {
        if let index = hobbies.firstIndex(where: { $0.id == hobbyId }) {
            hobbies[index].ideas.append(idea)
        }
    }
    
    func deleteIdea(_ idea: Idea, from hobbyId: UUID) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }) {
            hobbies[hobbyIndex].ideas.removeAll { $0.id == idea.id }
        }
    }
    
    func toggleIdeaFavorite(_ idea: Idea, in hobbyId: UUID) {
        if let hobbyIndex = hobbies.firstIndex(where: { $0.id == hobbyId }),
           let ideaIndex = hobbies[hobbyIndex].ideas.firstIndex(where: { $0.id == idea.id }) {
            hobbies[hobbyIndex].ideas[ideaIndex].isFavorite.toggle()
        }
    }
    
    // MARK: - Analytics
    
    func getTotalTimeSpent() -> TimeInterval {
        hobbies.reduce(0) { $0 + $1.totalTimeSpent }
    }
    
    func getWeeklyStats() -> [String: TimeInterval] {
        var stats: [String: TimeInterval] = [:]
        let calendar = Calendar.current
        let startOfWeek = Date().startOfWeek()
        
        for hobby in hobbies {
            let sessions = getAllSessions(for: hobby.id)
            let weeklySessions = sessions.filter { session in
                calendar.isDate(session.date, equalTo: startOfWeek, toGranularity: .weekOfYear)
            }
            stats[hobby.name] = weeklySessions.reduce(0) { $0 + $1.duration }
        }
        
        return stats
    }
    
    // MARK: - Achievements
    
    func checkAchievements() {
        // First Session
        if !userProfile.achievements.contains(where: { $0.title == "First Steps" }) {
            let totalSessions = hobbies.flatMap { getAllSessions(for: $0.id) }.count
            if totalSessions >= 1 {
                unlockAchievement(Achievement(
                    title: "First Steps",
                    description: "Complete your first session",
                    icon: "flag.fill",
                    category: .milestone
                ))
            }
        }
        
        // 5 Hobbies
        if !userProfile.achievements.contains(where: { $0.title == "Diverse Interests" }) {
            if hobbies.count >= 5 {
                unlockAchievement(Achievement(
                    title: "Diverse Interests",
                    description: "Track 5 different hobbies",
                    icon: "star.fill",
                    category: .variety
                ))
            }
        }
        
        // Level 10
        if !userProfile.achievements.contains(where: { $0.title == "Rising Star" }) {
            if userProfile.level >= 10 {
                unlockAchievement(Achievement(
                    title: "Rising Star",
                    description: "Reach level 10",
                    icon: "sparkles",
                    category: .mastery
                ))
            }
        }
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        var newAchievement = achievement
        newAchievement.isUnlocked = true
        newAchievement.unlockedDate = Date()
        userProfile.achievements.append(newAchievement)
    }
}
