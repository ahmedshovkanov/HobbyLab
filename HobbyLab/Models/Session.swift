import Foundation

struct Session: Identifiable, Codable, Equatable {
    var id = UUID()
    var projectId: UUID?
    var hobbyId: UUID
    var date: Date
    var duration: TimeInterval // in seconds
    var notes: String
    var tags: [String]
    var mediaUrls: [String] // URLs to images/videos
    var xpEarned: Int
    
    init(hobbyId: UUID, projectId: UUID? = nil, duration: TimeInterval, notes: String = "", tags: [String] = []) {
        self.hobbyId = hobbyId
        self.projectId = projectId
        self.date = Date()
        self.duration = duration
        self.notes = notes
        self.tags = tags
        self.mediaUrls = []
        self.xpEarned = Session.calculateXP(for: duration)
    }
    
    static func calculateXP(for duration: TimeInterval) -> Int {
        // 10 XP per hour
        return Int((duration / 3600.0) * 10)
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
