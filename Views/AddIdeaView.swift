import SwiftUI

struct AddIdeaView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    let hobbyId: UUID
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var link = ""
    @State private var links: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Idea Details")) {
                    TextField("Title", text: $title)
                    
                    TextField("Description", text: $content, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section(header: Text("Tags")) {
                    TextField("Tags (comma separated)", text: $tags)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Links")) {
                    HStack {
                        TextField("Add a link", text: $link)
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                        
                        Button(action: addLink) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.hobbyLabPrimary)
                        }
                        .disabled(link.isEmpty)
                    }
                    
                    ForEach(links, id: \.self) { savedLink in
                        HStack {
                            Text(savedLink)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button(action: { removeLink(savedLink) }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: saveIdea) {
                        Text("Save Idea")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.hobbyLabPrimary)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addLink() {
        guard !link.isEmpty else { return }
        links.append(link)
        link = ""
    }
    
    private func removeLink(_ link: String) {
        links.removeAll { $0 == link }
    }
    
    private func saveIdea() {
        let tagArray = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        var idea = Idea(
            hobbyId: hobbyId,
            title: title,
            content: content,
            tags: tagArray
        )
        idea.links = links
        
        viewModel.addIdea(idea, to: hobbyId)
        dismiss()
    }
}

#Preview {
    AddIdeaView(hobbyId: UUID())
        .environmentObject(HobbyViewModel())
}
