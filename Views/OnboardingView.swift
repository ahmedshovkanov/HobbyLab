import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @State private var currentPage = 0
    @State private var name = ""
    @State private var selectedEmoji = "🎨"
    @State private var selectedHobbies: Set<HobbyCategory> = []
    
    let emojiOptions = ["🎨", "🎸", "⚽️", "💻", "✍️", "🌱", "🍳", "✂️", "📸", "📚", "🎮", "🏃"]
    
    var body: some View {
        ZStack {
            Color.hobbyLabSecondaryBackground.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Welcome Page
                welcomePage
                    .tag(0)
                
                // Name & Avatar Page
                profilePage
                    .tag(1)
                
                // Interests Page
                interestsPage
                    .tag(2)
                
                // Ready Page
                readyPage
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
    
    private var welcomePage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Logo/Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.hobbyLabPrimary, Color(hex: "#9C27B0")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            // Title & Tagline
            VStack(spacing: 12) {
                Text("ArctiLab")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.hobbyLabText)
                
                Text("Plan, track, and grow your hobbies\n— all in one place.")
                    .font(.title3)
                    .foregroundColor(.hobbyLabSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: { withAnimation { currentPage = 1 } }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.hobbyLabPrimary)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var profilePage: some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Text("Let's get to know you")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Personalize your experience")
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
            .padding(.top, 60)
            
            // Avatar Selection
            VStack(spacing: 20) {
                Text(selectedEmoji)
                    .font(.system(size: 80))
                    .frame(width: 140, height: 140)
                    .background(
                        Circle()
                            .fill(Color.hobbyLabPrimary.opacity(0.1))
                    )
                
                Text("Choose your avatar")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                    ForEach(emojiOptions, id: \.self) { emoji in
                        Button(action: { selectedEmoji = emoji }) {
                            Text(emoji)
                                .font(.system(size: 32))
                                .frame(width: 50, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedEmoji == emoji ? Color.hobbyLabPrimary.opacity(0.2) : Color.hobbyLabSecondaryBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedEmoji == emoji ? Color.hobbyLabPrimary : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            
            // Name Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Your name")
                    .font(.headline)
                
                TextField("Enter your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Continue Button
            Button(action: { withAnimation { currentPage = 2 } }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Color.hobbyLabPrimary)
                    .cornerRadius(12)
            }
            .disabled(name.isEmpty)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var interestsPage: some View {
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Text("What are your interests?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Select your favorite hobbies to get started")
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            .padding(.horizontal, 40)
            
            // Hobby Categories Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(HobbyCategory.allCases, id: \.self) { category in
                        HobbyCategoryCard(
                            category: category,
                            isSelected: selectedHobbies.contains(category)
                        ) {
                            if selectedHobbies.contains(category) {
                                selectedHobbies.remove(category)
                            } else {
                                selectedHobbies.insert(category)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: { withAnimation { currentPage = 3 } }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedHobbies.isEmpty ? Color.gray : Color.hobbyLabPrimary)
                    .cornerRadius(12)
            }
            .disabled(selectedHobbies.isEmpty)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var readyPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success Icon
            ZStack {
                Circle()
                    .fill(Color.hobbyLabSuccess.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.hobbyLabSuccess)
            }
            
            // Message
            VStack(spacing: 12) {
                Text("You're all set!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Start tracking your hobbies and\nwatch your progress grow.")
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            // Quick Stats
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    OnboardingStatItem(icon: "heart.fill", text: "\(selectedHobbies.count) interests")
                    OnboardingStatItem(icon: "star.fill", text: "Level 1")
                }
                
                Text("Ready to begin your journey")
                    .font(.caption)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
            .padding()
            .background(Color.hobbyLabCard)
            .cornerRadius(16)
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Start Button
            Button(action: completeOnboarding) {
                Text("Start Your Journey")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.hobbyLabPrimary, Color(hex: "#9C27B0")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private func completeOnboarding() {
        // Update user profile
        viewModel.userProfile.name = name
        viewModel.userProfile.avatarEmoji = selectedEmoji
        
        // Create initial hobbies
        for category in selectedHobbies {
            let hobby = Hobby(
                name: category.rawValue,
                category: category,
                color: getRandomColor(),
                icon: category.icon
            )
            viewModel.addHobby(hobby)
        }
        
        // Mark onboarding as complete
        hasCompletedOnboarding = true
    }
    
    private func getRandomColor() -> String {
        let colors = ["#55BEEB", "#FF6B9D", "#9C27B0", "#4CAF50", "#FF9800", "#2196F3", "#FFC107"]
        return colors.randomElement() ?? "#55BEEB"
    }
}

struct HobbyCategoryCard: View {
    let category: HobbyCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.title)
                    .foregroundColor(isSelected ? .white : .hobbyLabPrimary)
                
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .hobbyLabText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.hobbyLabPrimary : Color.hobbyLabCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.hobbyLabPrimary.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingStatItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.hobbyLabPrimary)
            
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.hobbyLabPrimary.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(HobbyViewModel())
}
