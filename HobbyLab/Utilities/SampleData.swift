import Foundation

struct SampleData {
    static func generateSampleHobbies() -> [Hobby] {
        var hobbies: [Hobby] = []
        
        // Calculate dates for the past month
        let now = Date()
        let calendar = Calendar.current
        
        // Hobby 1: Photography
        var photography = Hobby(
            name: "Photography",
            category: .photography,
            color: "#FF6B6B",
            icon: "camera.fill"
        )
        photography.createdDate = calendar.date(byAdding: .day, value: -35, to: now)!
        photography.totalTimeSpent = 43200 // 12 hours
        photography.currentStreak = 3
        photography.longestStreak = 7
        
        // Photography Projects
        var portraitProject = Project(
            hobbyId: photography.id,
            name: "Portrait Series",
            description: "Capture 20 unique portraits with natural lighting",
            targetEndDate: calendar.date(byAdding: .day, value: 15, to: now)
        )
        portraitProject.startDate = calendar.date(byAdding: .day, value: -25, to: now)!
        portraitProject.progress = 0.65
        
        // Portrait project tasks
        portraitProject.tasks = [
            ProjectTask(projectId: portraitProject.id, title: "Research lighting techniques", description: "Study natural light photography", priority: .high),
            ProjectTask(projectId: portraitProject.id, title: "Find 10 models", description: "", priority: .high),
            ProjectTask(projectId: portraitProject.id, title: "Scout outdoor locations", description: "Find 3-5 good spots", priority: .medium),
            ProjectTask(projectId: portraitProject.id, title: "Edit first batch (10 photos)", description: "", priority: .medium),
            ProjectTask(projectId: portraitProject.id, title: "Complete second batch", description: "", priority: .low)
        ]
        portraitProject.tasks[0].isCompleted = true
        portraitProject.tasks[0].completedDate = calendar.date(byAdding: .day, value: -24, to: now)
        portraitProject.tasks[1].isCompleted = true
        portraitProject.tasks[1].completedDate = calendar.date(byAdding: .day, value: -20, to: now)
        portraitProject.tasks[2].isCompleted = true
        portraitProject.tasks[2].completedDate = calendar.date(byAdding: .day, value: -15, to: now)
        
        // Portrait project sessions
        portraitProject.sessions = [
            Session(hobbyId: photography.id, projectId: portraitProject.id, duration: 5400, notes: "Shot 3 portraits in the park, golden hour lighting was perfect!", tags: ["outdoor", "golden-hour"]),
            Session(hobbyId: photography.id, projectId: portraitProject.id, duration: 7200, notes: "Indoor studio session, experimenting with reflectors", tags: ["studio", "lighting"]),
            Session(hobbyId: photography.id, projectId: portraitProject.id, duration: 3600, notes: "Editing session - color grading", tags: ["editing", "lightroom"]),
            Session(hobbyId: photography.id, projectId: portraitProject.id, duration: 4500, notes: "Beach portraits at sunset", tags: ["outdoor", "sunset"])
        ]
        portraitProject.sessions[0].date = calendar.date(byAdding: .day, value: -22, to: now)!
        portraitProject.sessions[1].date = calendar.date(byAdding: .day, value: -18, to: now)!
        portraitProject.sessions[2].date = calendar.date(byAdding: .day, value: -12, to: now)!
        portraitProject.sessions[3].date = calendar.date(byAdding: .day, value: -5, to: now)!
        
        var landscapeProject = Project(
            hobbyId: photography.id,
            name: "Local Landscapes",
            description: "Document beautiful spots around the city",
            targetEndDate: nil
        )
        landscapeProject.startDate = calendar.date(byAdding: .day, value: -15, to: now)!
        landscapeProject.progress = 0.3
        
        landscapeProject.sessions = [
            Session(hobbyId: photography.id, projectId: landscapeProject.id, duration: 6300, notes: "Early morning shoot at the lake", tags: ["landscape", "sunrise"]),
            Session(hobbyId: photography.id, projectId: landscapeProject.id, duration: 5100, notes: "City skyline from hilltop", tags: ["cityscape", "evening"])
        ]
        landscapeProject.sessions[0].date = calendar.date(byAdding: .day, value: -10, to: now)!
        landscapeProject.sessions[1].date = calendar.date(byAdding: .day, value: -3, to: now)!
        
        photography.projects = [portraitProject, landscapeProject]
        
        // Photography Ideas
        photography.ideas = [
            Idea(hobbyId: photography.id, title: "Black & White Street Series", content: "Capture urban life in monochrome. Focus on shadows, textures, and candid moments.", tags: ["street", "b&w"]),
            Idea(hobbyId: photography.id, title: "Macro Water Drops", content: "Experiment with water droplet photography using macro lens", tags: ["macro", "water"]),
            Idea(hobbyId: photography.id, title: "Long Exposure Light Trails", content: "Try night photography with car light trails on the highway", tags: ["night", "long-exposure"])
        ]
        photography.ideas[0].createdDate = calendar.date(byAdding: .day, value: -20, to: now)!
        photography.ideas[0].isFavorite = true
        photography.ideas[1].createdDate = calendar.date(byAdding: .day, value: -14, to: now)!
        photography.ideas[2].createdDate = calendar.date(byAdding: .day, value: -7, to: now)!
        
        hobbies.append(photography)
        
        // Hobby 2: Coding
        var coding = Hobby(
            name: "iOS Development",
            category: .coding,
            color: "#4ECDC4",
            icon: "chevron.left.forwardslash.chevron.right"
        )
        coding.createdDate = calendar.date(byAdding: .day, value: -40, to: now)!
        coding.totalTimeSpent = 86400 // 24 hours
        coding.currentStreak = 5
        coding.longestStreak = 12
        
        var todoAppProject = Project(
            hobbyId: coding.id,
            name: "Personal Todo App",
            description: "Build a SwiftUI todo app with Core Data",
            targetEndDate: calendar.date(byAdding: .day, value: 20, to: now)
        )
        todoAppProject.startDate = calendar.date(byAdding: .day, value: -30, to: now)!
        todoAppProject.progress = 0.75
        
        todoAppProject.tasks = [
            ProjectTask(projectId: todoAppProject.id, title: "Set up Core Data model", priority: .high),
            ProjectTask(projectId: todoAppProject.id, title: "Design main UI in SwiftUI", priority: .high),
            ProjectTask(projectId: todoAppProject.id, title: "Implement CRUD operations", priority: .high),
            ProjectTask(projectId: todoAppProject.id, title: "Add categories feature", priority: .medium),
            ProjectTask(projectId: todoAppProject.id, title: "Implement search", priority: .medium),
            ProjectTask(projectId: todoAppProject.id, title: "Add widgets", priority: .low),
            ProjectTask(projectId: todoAppProject.id, title: "Polish animations", priority: .low)
        ]
        todoAppProject.tasks[0].isCompleted = true
        todoAppProject.tasks[0].completedDate = calendar.date(byAdding: .day, value: -28, to: now)
        todoAppProject.tasks[1].isCompleted = true
        todoAppProject.tasks[1].completedDate = calendar.date(byAdding: .day, value: -25, to: now)
        todoAppProject.tasks[2].isCompleted = true
        todoAppProject.tasks[2].completedDate = calendar.date(byAdding: .day, value: -20, to: now)
        todoAppProject.tasks[3].isCompleted = true
        todoAppProject.tasks[3].completedDate = calendar.date(byAdding: .day, value: -15, to: now)
        todoAppProject.tasks[4].isCompleted = true
        todoAppProject.tasks[4].completedDate = calendar.date(byAdding: .day, value: -10, to: now)
        
        todoAppProject.sessions = [
            Session(hobbyId: coding.id, projectId: todoAppProject.id, duration: 7200, notes: "Initial project setup and Core Data configuration", tags: ["setup", "coredata"]),
            Session(hobbyId: coding.id, projectId: todoAppProject.id, duration: 5400, notes: "Building the main list view and add task sheet", tags: ["swiftui", "ui"]),
            Session(hobbyId: coding.id, projectId: todoAppProject.id, duration: 9000, notes: "Implementing all CRUD operations with Core Data", tags: ["coredata", "logic"]),
            Session(hobbyId: coding.id, projectId: todoAppProject.id, duration: 6300, notes: "Added category system with color coding", tags: ["features", "ui"]),
            Session(hobbyId: coding.id, projectId: todoAppProject.id, duration: 4200, notes: "Search functionality with filtering", tags: ["features", "search"]),
            Session(hobbyId: coding.id, projectId: todoAppProject.id, duration: 3600, notes: "Bug fixes and UI improvements", tags: ["bugfix", "polish"])
        ]
        todoAppProject.sessions[0].date = calendar.date(byAdding: .day, value: -28, to: now)!
        todoAppProject.sessions[1].date = calendar.date(byAdding: .day, value: -24, to: now)!
        todoAppProject.sessions[2].date = calendar.date(byAdding: .day, value: -19, to: now)!
        todoAppProject.sessions[3].date = calendar.date(byAdding: .day, value: -14, to: now)!
        todoAppProject.sessions[4].date = calendar.date(byAdding: .day, value: -9, to: now)!
        todoAppProject.sessions[5].date = calendar.date(byAdding: .day, value: -4, to: now)!
        
        var algorithmsProject = Project(
            hobbyId: coding.id,
            name: "Algorithm Practice",
            description: "Daily algorithm challenges on LeetCode",
            targetEndDate: nil
        )
        algorithmsProject.startDate = calendar.date(byAdding: .day, value: -35, to: now)!
        algorithmsProject.progress = 0.4
        
        algorithmsProject.sessions = [
            Session(hobbyId: coding.id, projectId: algorithmsProject.id, duration: 3600, notes: "Solved 3 array problems", tags: ["arrays", "leetcode"]),
            Session(hobbyId: coding.id, projectId: algorithmsProject.id, duration: 5400, notes: "Binary tree traversal practice", tags: ["trees", "recursion"]),
            Session(hobbyId: coding.id, projectId: algorithmsProject.id, duration: 3000, notes: "Dynamic programming intro problems", tags: ["dp", "hard"])
        ]
        algorithmsProject.sessions[0].date = calendar.date(byAdding: .day, value: -26, to: now)!
        algorithmsProject.sessions[1].date = calendar.date(byAdding: .day, value: -17, to: now)!
        algorithmsProject.sessions[2].date = calendar.date(byAdding: .day, value: -8, to: now)!
        
        coding.projects = [todoAppProject, algorithmsProject]
        
        coding.ideas = [
            Idea(hobbyId: coding.id, title: "Weather App with Animations", content: "Create a beautiful weather app using SwiftUI animations and WeatherKit", tags: ["swiftui", "animations", "api"]),
            Idea(hobbyId: coding.id, title: "Markdown Note App", content: "Build a note-taking app with markdown support and iCloud sync", tags: ["swiftui", "icloud"]),
            Idea(hobbyId: coding.id, title: "Budget Tracker", content: "Personal finance app with charts and insights", tags: ["charts", "coredata"]),
            Idea(hobbyId: coding.id, title: "Habit Tracker Widget", content: "Simple habit tracking with home screen widgets", tags: ["widgets", "swiftui"])
        ]
        coding.ideas[0].createdDate = calendar.date(byAdding: .day, value: -21, to: now)!
        coding.ideas[0].isFavorite = true
        coding.ideas[1].createdDate = calendar.date(byAdding: .day, value: -16, to: now)!
        coding.ideas[1].isFavorite = true
        coding.ideas[2].createdDate = calendar.date(byAdding: .day, value: -11, to: now)!
        coding.ideas[3].createdDate = calendar.date(byAdding: .day, value: -5, to: now)!
        
        hobbies.append(coding)
        
        // Hobby 3: Guitar
        var guitar = Hobby(
            name: "Guitar",
            category: .music,
            color: "#FFD93D",
            icon: "guitars.fill"
        )
        guitar.createdDate = calendar.date(byAdding: .day, value: -28, to: now)!
        guitar.totalTimeSpent = 32400 // 9 hours
        guitar.currentStreak = 2
        guitar.longestStreak = 8
        
        var songLearningProject = Project(
            hobbyId: guitar.id,
            name: "Learn Classic Songs",
            description: "Master 5 classic rock songs",
            targetEndDate: calendar.date(byAdding: .day, value: 30, to: now)
        )
        songLearningProject.startDate = calendar.date(byAdding: .day, value: -20, to: now)!
        songLearningProject.progress = 0.5
        
        songLearningProject.tasks = [
            ProjectTask(projectId: songLearningProject.id, title: "Learn 'Wonderwall' chords", priority: .high),
            ProjectTask(projectId: songLearningProject.id, title: "Master 'Hotel California' intro", priority: .high),
            ProjectTask(projectId: songLearningProject.id, title: "Practice 'Stairway to Heaven'", priority: .medium),
            ProjectTask(projectId: songLearningProject.id, title: "Learn 'Blackbird' fingerpicking", priority: .medium),
            ProjectTask(projectId: songLearningProject.id, title: "Memorize 'Tears in Heaven'", priority: .low)
        ]
        songLearningProject.tasks[0].isCompleted = true
        songLearningProject.tasks[0].completedDate = calendar.date(byAdding: .day, value: -18, to: now)
        songLearningProject.tasks[1].isCompleted = true
        songLearningProject.tasks[1].completedDate = calendar.date(byAdding: .day, value: -12, to: now)
        
        songLearningProject.sessions = [
            Session(hobbyId: guitar.id, projectId: songLearningProject.id, duration: 3600, notes: "Practiced chord transitions for Wonderwall", tags: ["chords", "practice"]),
            Session(hobbyId: guitar.id, projectId: songLearningProject.id, duration: 5400, notes: "Worked on Hotel California solo, slow practice", tags: ["solo", "technique"]),
            Session(hobbyId: guitar.id, projectId: songLearningProject.id, duration: 4200, notes: "Fingerpicking patterns practice", tags: ["fingerpicking"]),
            Session(hobbyId: guitar.id, projectId: songLearningProject.id, duration: 3000, notes: "Full run-through of learned songs", tags: ["performance", "practice"])
        ]
        songLearningProject.sessions[0].date = calendar.date(byAdding: .day, value: -17, to: now)!
        songLearningProject.sessions[1].date = calendar.date(byAdding: .day, value: -11, to: now)!
        songLearningProject.sessions[2].date = calendar.date(byAdding: .day, value: -6, to: now)!
        songLearningProject.sessions[3].date = calendar.date(byAdding: .day, value: -2, to: now)!
        
        guitar.projects = [songLearningProject]
        
        guitar.ideas = [
            Idea(hobbyId: guitar.id, title: "Write Original Song", content: "Compose an original piece combining fingerstyle and strumming", tags: ["composition", "original"]),
            Idea(hobbyId: guitar.id, title: "Learn Jazz Standards", content: "Start learning basic jazz chord voicings and standards", tags: ["jazz", "theory"]),
            Idea(hobbyId: guitar.id, title: "Record Cover Songs", content: "Set up home recording to share covers on social media", tags: ["recording", "covers"])
        ]
        guitar.ideas[0].createdDate = calendar.date(byAdding: .day, value: -13, to: now)!
        guitar.ideas[0].isFavorite = true
        guitar.ideas[1].createdDate = calendar.date(byAdding: .day, value: -9, to: now)!
        guitar.ideas[2].createdDate = calendar.date(byAdding: .day, value: -4, to: now)!
        
        hobbies.append(guitar)
        
        // Hobby 4: Drawing
        var drawing = Hobby(
            name: "Digital Art",
            category: .art,
            color: "#A8E6CF",
            icon: "paintbrush.fill"
        )
        drawing.createdDate = calendar.date(byAdding: .day, value: -22, to: now)!
        drawing.totalTimeSpent = 25200 // 7 hours
        drawing.currentStreak = 1
        drawing.longestStreak = 5
        
        var characterDesignProject = Project(
            hobbyId: drawing.id,
            name: "Character Design Series",
            description: "Create 10 unique character designs",
            targetEndDate: calendar.date(byAdding: .day, value: 25, to: now)
        )
        characterDesignProject.startDate = calendar.date(byAdding: .day, value: -18, to: now)!
        characterDesignProject.progress = 0.4
        
        characterDesignProject.tasks = [
            ProjectTask(projectId: characterDesignProject.id, title: "Research character design fundamentals", priority: .high),
            ProjectTask(projectId: characterDesignProject.id, title: "Sketch 20 concept thumbnails", priority: .high),
            ProjectTask(projectId: characterDesignProject.id, title: "Refine 4 designs", priority: .medium),
            ProjectTask(projectId: characterDesignProject.id, title: "Color 4 characters", priority: .medium)
        ]
        characterDesignProject.tasks[0].isCompleted = true
        characterDesignProject.tasks[0].completedDate = calendar.date(byAdding: .day, value: -16, to: now)
        characterDesignProject.tasks[1].isCompleted = true
        characterDesignProject.tasks[1].completedDate = calendar.date(byAdding: .day, value: -11, to: now)
        
        characterDesignProject.sessions = [
            Session(hobbyId: drawing.id, projectId: characterDesignProject.id, duration: 5400, notes: "Watched tutorials and sketched basic shapes", tags: ["learning", "sketching"]),
            Session(hobbyId: drawing.id, projectId: characterDesignProject.id, duration: 6300, notes: "Rapid thumbnailing session - lots of ideas!", tags: ["sketching", "ideation"]),
            Session(hobbyId: drawing.id, projectId: characterDesignProject.id, duration: 7200, notes: "Refined 3 character designs with details", tags: ["refinement", "details"])
        ]
        characterDesignProject.sessions[0].date = calendar.date(byAdding: .day, value: -15, to: now)!
        characterDesignProject.sessions[1].date = calendar.date(byAdding: .day, value: -10, to: now)!
        characterDesignProject.sessions[2].date = calendar.date(byAdding: .day, value: -5, to: now)!
        
        drawing.projects = [characterDesignProject]
        
        drawing.ideas = [
            Idea(hobbyId: drawing.id, title: "Daily Doodle Challenge", content: "One simple doodle every day for 30 days", tags: ["challenge", "daily"]),
            Idea(hobbyId: drawing.id, title: "Environment Concept Art", content: "Practice drawing landscapes and cityscapes", tags: ["environment", "concept-art"]),
            Idea(hobbyId: drawing.id, title: "Animation Loop", content: "Create a simple looping animation in Procreate", tags: ["animation", "procreate"])
        ]
        drawing.ideas[0].createdDate = calendar.date(byAdding: .day, value: -12, to: now)!
        drawing.ideas[1].createdDate = calendar.date(byAdding: .day, value: -8, to: now)!
        drawing.ideas[1].isFavorite = true
        drawing.ideas[2].createdDate = calendar.date(byAdding: .day, value: -3, to: now)!
        
        hobbies.append(drawing)
        
        // Hobby 5: Cooking
        var cooking = Hobby(
            name: "Cooking",
            category: .cooking,
            color: "#FF8B94",
            icon: "fork.knife"
        )
        cooking.createdDate = calendar.date(byAdding: .day, value: -15, to: now)!
        cooking.totalTimeSpent = 18000 // 5 hours
        cooking.currentStreak = 1
        cooking.longestStreak = 4
        
        var bakinProject = Project(
            hobbyId: cooking.id,
            name: "Master Sourdough",
            description: "Learn to bake perfect sourdough bread",
            targetEndDate: nil
        )
        bakinProject.startDate = calendar.date(byAdding: .day, value: -12, to: now)!
        bakinProject.progress = 0.35
        
        bakinProject.tasks = [
            ProjectTask(projectId: bakinProject.id, title: "Create starter culture", priority: .high),
            ProjectTask(projectId: bakinProject.id, title: "First bread attempt", priority: .high),
            ProjectTask(projectId: bakinProject.id, title: "Perfect the timeline", priority: .medium),
            ProjectTask(projectId: bakinProject.id, title: "Experiment with different flours", priority: .low)
        ]
        bakinProject.tasks[0].isCompleted = true
        bakinProject.tasks[0].completedDate = calendar.date(byAdding: .day, value: -10, to: now)
        
        bakinProject.sessions = [
            Session(hobbyId: cooking.id, projectId: bakinProject.id, duration: 3600, notes: "Started sourdough starter, fed it", tags: ["sourdough", "starter"]),
            Session(hobbyId: cooking.id, projectId: bakinProject.id, duration: 5400, notes: "First bake! A bit dense but tasty", tags: ["baking", "attempt1"]),
            Session(hobbyId: cooking.id, projectId: bakinProject.id, duration: 6000, notes: "Second attempt - better rise!", tags: ["baking", "improvement"])
        ]
        bakinProject.sessions[0].date = calendar.date(byAdding: .day, value: -9, to: now)!
        bakinProject.sessions[1].date = calendar.date(byAdding: .day, value: -5, to: now)!
        bakinProject.sessions[2].date = calendar.date(byAdding: .day, value: -1, to: now)!
        
        cooking.projects = [bakinProject]
        
        cooking.ideas = [
            Idea(hobbyId: cooking.id, title: "Pasta from Scratch", content: "Learn to make fresh pasta - tagliatelle, ravioli", tags: ["pasta", "italian"]),
            Idea(hobbyId: cooking.id, title: "Global Cuisine Challenge", content: "Cook one dish from 10 different countries", tags: ["challenge", "global"]),
            Idea(hobbyId: cooking.id, title: "Knife Skills Practice", content: "Improve cutting techniques and speed", tags: ["skills", "technique"])
        ]
        cooking.ideas[0].createdDate = calendar.date(byAdding: .day, value: -8, to: now)!
        cooking.ideas[0].isFavorite = true
        cooking.ideas[1].createdDate = calendar.date(byAdding: .day, value: -6, to: now)!
        cooking.ideas[2].createdDate = calendar.date(byAdding: .day, value: -2, to: now)!
        
        hobbies.append(cooking)
        
        return hobbies
    }
    
    static func generateSampleUserProfile() -> UserProfile {
        let calendar = Calendar.current
        let now = Date()
        
        var profile = UserProfile(name: "Alex", avatarEmoji: "🎨")
        profile.joinDate = calendar.date(byAdding: .day, value: -40, to: now)!
        
        // Calculate total XP from all sessions
        // Total time spent across all hobbies: ~27 hours
        // At 10 XP per hour = ~270 XP
        profile.totalXP = 270
        profile.level = 3 // Level 1 = 100 XP, Level 2 = 200 XP, Level 3 = 300 XP
        profile.currentXP = 70 // 70 XP into level 3 (needs 300 for level 4)
        
        // Add some sample achievements
        profile.achievements = [
            Achievement(
                title: "First Steps",
                description: "Create your first hobby",
                icon: "star.fill",
                category: .milestone
            ),
            Achievement(
                title: "Project Starter",
                description: "Start your first project",
                icon: "folder.fill",
                category: .milestone
            ),
            Achievement(
                title: "Dedicated",
                description: "Maintain a 7-day streak",
                icon: "flame.fill",
                category: .consistency
            ),
            Achievement(
                title: "Multi-talented",
                description: "Have 5 active hobbies",
                icon: "sparkles",
                category: .variety
            ),
            Achievement(
                title: "Level 3",
                description: "Reach level 3",
                icon: "arrow.up.circle.fill",
                category: .milestone
            ),
            Achievement(
                title: "Marathon Session",
                description: "Complete a 3+ hour session",
                icon: "timer",
                category: .mastery
            ),
            Achievement(
                title: "Completionist",
                description: "Complete 10 projects",
                icon: "checkmark.seal.fill",
                category: .mastery
            )
        ]
        
        // Unlock the first 5 achievements
        profile.achievements[0].isUnlocked = true
        profile.achievements[0].unlockedDate = calendar.date(byAdding: .day, value: -40, to: now)
        profile.achievements[1].isUnlocked = true
        profile.achievements[1].unlockedDate = calendar.date(byAdding: .day, value: -30, to: now)
        profile.achievements[2].isUnlocked = true
        profile.achievements[2].unlockedDate = calendar.date(byAdding: .day, value: -15, to: now)
        profile.achievements[3].isUnlocked = true
        profile.achievements[3].unlockedDate = calendar.date(byAdding: .day, value: -10, to: now)
        profile.achievements[4].isUnlocked = true
        profile.achievements[4].unlockedDate = calendar.date(byAdding: .day, value: -5, to: now)
        
        return profile
    }
}
