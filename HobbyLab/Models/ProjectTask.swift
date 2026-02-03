import Foundation

struct ProjectTask: Identifiable, Codable, Equatable {
    var id = UUID()
    var projectId: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var completedDate: Date?
    var createdDate: Date
    var priority: TaskPriority
    
    init(projectId: UUID, title: String, description: String = "", priority: TaskPriority = .medium) {
        self.projectId = projectId
        self.title = title
        self.description = description
        self.isCompleted = false
        self.completedDate = nil
        self.createdDate = Date()
        self.priority = priority
    }
}

enum TaskPriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: String {
        switch self {
        case .low: return "#4CAF50"
        case .medium: return "#FF9800"
        case .high: return "#F44336"
        }
    }
}
