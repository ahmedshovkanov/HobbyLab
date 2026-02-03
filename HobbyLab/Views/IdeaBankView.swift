import SwiftUI

struct IdeaBankView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    let hobbyId: UUID
    
    @State private var showingAddIdea = false
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    
    var hobby: Hobby? {
        viewModel.hobbies.first { $0.id == hobbyId }
    }
    
    var filteredIdeas: [Idea] {
        guard let hobby = hobby else { return [] }
        
        var ideas = hobby.ideas
        
        if showFavoritesOnly {
            ideas = ideas.filter { $0.isFavorite }
        }
        
        if !searchText.isEmpty {
            ideas = ideas.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return ideas.sorted { $0.createdDate > $1.createdDate }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.hobbyLabSecondaryText)
                        
                        TextField("Search ideas...", text: $searchText)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.hobbyLabSecondaryText)
                            }
                        }
                    }
                    .padding()
                    .background(Color.hobbyLabSecondaryBackground)
                    .cornerRadius(12)
                    
                    Toggle("Favorites Only", isOn: $showFavoritesOnly)
                        .tint(.hobbyLabPrimary)
                }
                .padding()
                .background(Color.hobbyLabCard)
                
                // Ideas List
                if filteredIdeas.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "lightbulb.fill",
                        title: showFavoritesOnly ? "No favorite ideas" : (searchText.isEmpty ? "No ideas yet" : "No matching ideas"),
                        message: showFavoritesOnly ? "Star your favorite ideas to see them here" : (searchText.isEmpty ? "Tap + to add your first idea" : "Try a different search")
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredIdeas) { idea in
                                IdeaCard(idea: idea, hobbyId: hobbyId)
                            }
                        }
                        .padding()
                    }
                    .background(Color.hobbyLabSecondaryBackground)
                }
            }
            .navigationTitle("Ideas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddIdea = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddIdea) {
                AddIdeaView(hobbyId: hobbyId)
            }
        }
    }
}

struct IdeaCard: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    let idea: Idea
    let hobbyId: UUID
    
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(idea.title)
                        .font(.headline)
                        .foregroundColor(.hobbyLabText)
                    
                    Spacer()
                    
                    Button(action: { viewModel.toggleIdeaFavorite(idea, in: hobbyId) }) {
                        Image(systemName: idea.isFavorite ? "star.fill" : "star")
                            .foregroundColor(idea.isFavorite ? .yellow : .hobbyLabSecondaryText)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if !idea.content.isEmpty {
                    Text(idea.content)
                        .font(.subheadline)
                        .foregroundColor(.hobbyLabSecondaryText)
                        .lineLimit(3)
                }
                
                if !idea.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(idea.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .foregroundColor(.hobbyLabPrimary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.hobbyLabPrimary.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.hobbyLabSecondaryText)
                    
                    Text(idea.createdDate.formatted(style: "medium"))
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                    
                    Spacer()
                    
                    if !idea.links.isEmpty {
                        Label("\(idea.links.count)", systemImage: "link")
                            .font(.caption)
                            .foregroundColor(.hobbyLabSecondaryText)
                    }
                }
            }
            .padding()
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            IdeaDetailView(idea: idea, hobbyId: hobbyId)
        }
    }
}

struct IdeaDetailView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    let idea: Idea
    let hobbyId: UUID
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(idea.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Content
                    if !idea.content.isEmpty {
                        Text(idea.content)
                            .font(.body)
                            .foregroundColor(.hobbyLabText)
                    }
                    
                    // Tags
                    if !idea.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(idea.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.subheadline)
                                        .foregroundColor(.hobbyLabPrimary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.hobbyLabPrimary.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Links
                    if !idea.links.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Links")
                                .font(.headline)
                            
                            ForEach(idea.links, id: \.self) { link in
                                Link(destination: URL(string: link) ?? URL(string: "https://google.com")!) {
                                    HStack {
                                        Image(systemName: "link")
                                        Text(link)
                                            .lineLimit(1)
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.hobbyLabPrimary)
                                    .padding()
                                    .background(Color.hobbyLabPrimary.opacity(0.05))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Metadata
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Created")
                            .font(.caption)
                            .foregroundColor(.hobbyLabSecondaryText)
                        
                        Text(idea.createdDate.formatted(style: "long"))
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.hobbyLabSecondaryBackground)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Idea Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.toggleIdeaFavorite(idea, in: hobbyId) }) {
                        Image(systemName: idea.isFavorite ? "star.fill" : "star")
                            .foregroundColor(idea.isFavorite ? .yellow : .hobbyLabPrimary)
                    }
                }
            }
        }
    }
}

// Simple FlowLayout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize
        var positions: [CGPoint]
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var positions: [CGPoint] = []
            var size: CGSize = .zero
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)
                
                if currentX + subviewSize.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, subviewSize.height)
                currentX += subviewSize.width + spacing
                size.width = max(size.width, currentX - spacing)
            }
            
            size.height = currentY + lineHeight
            self.size = size
            self.positions = positions
        }
    }
}

#Preview {
    IdeaBankView(hobbyId: UUID())
        .environmentObject(HobbyViewModel())
}
