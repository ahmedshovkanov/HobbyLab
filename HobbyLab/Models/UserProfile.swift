import Foundation

struct UserProfile: Codable {
    var id = UUID()
    var name: String
    var avatarEmoji: String
    var level: Int
    var currentXP: Int
    var totalXP: Int
    var achievements: [Achievement]
    var joinDate: Date
    
    init(name: String, avatarEmoji: String = "🎨") {
        self.name = name
        self.avatarEmoji = avatarEmoji
        self.level = 1
        self.currentXP = 0
        self.totalXP = 0
        self.achievements = []
        self.joinDate = Date()
    }
    
    var xpForNextLevel: Int {
        return level * 100
    }
    
    var progressToNextLevel: Double {
        return Double(currentXP) / Double(xpForNextLevel)
    }
    
    mutating func addXP(_ amount: Int) {
        currentXP += amount
        totalXP += amount
        
        while currentXP >= xpForNextLevel {
            currentXP -= xpForNextLevel
            level += 1
        }
    }
}

struct Achievement: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var icon: String
    var unlockedDate: Date?
    var isUnlocked: Bool
    var category: AchievementCategory
    
    init(title: String, description: String, icon: String, category: AchievementCategory) {
        self.title = title
        self.description = description
        self.icon = icon
        self.unlockedDate = nil
        self.isUnlocked = false
        self.category = category
    }
}

enum AchievementCategory: String, Codable, CaseIterable {
    case consistency = "Consistency"
    case milestone = "Milestone"
    case variety = "Variety"
    case mastery = "Mastery"
}
