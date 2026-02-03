import Foundation

struct Idea: Identifiable, Codable, Equatable {
    var id = UUID()
    var hobbyId: UUID
    var title: String
    var content: String
    var links: [String]
    var tags: [String]
    var imageUrls: [String]
    var createdDate: Date
    var isFavorite: Bool
    
    init(hobbyId: UUID, title: String, content: String = "", tags: [String] = []) {
        self.hobbyId = hobbyId
        self.title = title
        self.content = content
        self.links = []
        self.tags = tags
        self.imageUrls = []
        self.createdDate = Date()
        self.isFavorite = false
    }
}
