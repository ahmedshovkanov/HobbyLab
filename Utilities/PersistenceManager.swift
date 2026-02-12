import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let hobbiesKey = "hobbies_data"
    private let userProfileKey = "user_profile_data"
    
    private init() {}
    
    // MARK: - Hobbies
    
    func saveHobbies(_ hobbies: [Hobby]) {
        // Temporarily disabled for screenshot mode
        // if let encoded = try? JSONEncoder().encode(hobbies) {
        //     UserDefaults.standard.set(encoded, forKey: hobbiesKey)
        // }
    }
    
    func loadHobbies() -> [Hobby] {
        // Return pregenerated sample data for screenshots
        return SampleData.generateSampleHobbies()
        
        // Original code (disabled for screenshots):
        // guard let data = UserDefaults.standard.data(forKey: hobbiesKey),
        //       let hobbies = try? JSONDecoder().decode([Hobby].self, from: data) else {
        //     return []
        // }
        // return hobbies
    }
    
    // MARK: - User Profile
    
    func saveUserProfile(_ profile: UserProfile) {
        // Temporarily disabled for screenshot mode
        // if let encoded = try? JSONEncoder().encode(profile) {
        //     UserDefaults.standard.set(encoded, forKey: userProfileKey)
        // }
    }
    
    func loadUserProfile() -> UserProfile? {
        // Return pregenerated sample data for screenshots
        return SampleData.generateSampleUserProfile()
        
        // Original code (disabled for screenshots):
        // guard let data = UserDefaults.standard.data(forKey: userProfileKey),
        //       let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
        //     return nil
        // }
        // return profile
    }
    
    // MARK: - Clear All Data
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: hobbiesKey)
        UserDefaults.standard.removeObject(forKey: userProfileKey)
    }
}
