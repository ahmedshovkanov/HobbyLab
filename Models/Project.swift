import Foundation

struct Project: Identifiable, Codable, Equatable {
    var id = UUID()
    var hobbyId: UUID
    var name: String
    var description: String
    var startDate: Date
    var targetEndDate: Date?
    var completionDate: Date?
    var progress: Double // 0.0 to 1.0
    var sessions: [Session]
    var tasks: [ProjectTask]
    var isCompleted: Bool
    
    init(hobbyId: UUID, name: String, description: String = "", targetEndDate: Date? = nil) {
        self.hobbyId = hobbyId
        self.name = name
        self.description = description
        self.startDate = Date()
        self.targetEndDate = targetEndDate
        self.completionDate = nil
        self.progress = 0.0
        self.sessions = []
        self.tasks = []
        self.isCompleted = false
    }
    
    var totalTimeSpent: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    mutating func updateProgress() {
        guard !tasks.isEmpty else {
            progress = sessions.isEmpty ? 0.0 : 0.5
            return
        }
        progress = Double(completedTasksCount) / Double(tasks.count)
    }
}
