import Foundation
import SwiftUI

struct Hobby: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var category: HobbyCategory
    var color: String // Hex color
    var icon: String // SF Symbol name
    var createdDate: Date
    var totalTimeSpent: TimeInterval // in seconds
    var currentStreak: Int
    var longestStreak: Int
    var projects: [Project]
    var ideas: [Idea]
    
    init(name: String, category: HobbyCategory, color: String = "#55BEEB", icon: String = "star.fill") {
        self.name = name
        self.category = category
        self.color = color
        self.icon = icon
        self.createdDate = Date()
        self.totalTimeSpent = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.projects = []
        self.ideas = []
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum HobbyCategory: String, Codable, CaseIterable {
    case art = "Art"
    case music = "Music"
    case sports = "Sports"
    case coding = "Coding"
    case writing = "Writing"
    case gardening = "Gardening"
    case cooking = "Cooking"
    case crafts = "Crafts"
    case photography = "Photography"
    case reading = "Reading"
    case gaming = "Gaming"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .art: return "paintbrush.fill"
        case .music: return "music.note"
        case .sports: return "figure.run"
        case .coding: return "chevron.left.forwardslash.chevron.right"
        case .writing: return "pencil.line"
        case .gardening: return "leaf.fill"
        case .cooking: return "fork.knife"
        case .crafts: return "scissors"
        case .photography: return "camera.fill"
        case .reading: return "book.fill"
        case .gaming: return "gamecontroller.fill"
        case .other: return "star.fill"
        }
    }
}
