import SwiftUI

struct AddHobbyView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var selectedCategory: HobbyCategory = .other
    @State private var selectedColor = "#55BEEB"
    @State private var selectedIcon = "star.fill"
    
    let colors = ["#55BEEB", "#FF6B9D", "#9C27B0", "#4CAF50", "#FF9800", "#F44336", "#2196F3", "#FFC107"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Hobby Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(HobbyCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Customize")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .font(.subheadline)
                            .foregroundColor(.hobbyLabSecondaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(hex: color))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.hobbyLabPrimary, lineWidth: selectedColor == color ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: addHobby) {
                        Text("Add Hobby")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.hobbyLabPrimary)
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("New Hobby")
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
    
    private func addHobby() {
        let hobby = Hobby(
            name: name,
            category: selectedCategory,
            color: selectedColor,
            icon: selectedCategory.icon
        )
        viewModel.addHobby(hobby)
        dismiss()
    }
}

#Preview {
    AddHobbyView()
        .environmentObject(HobbyViewModel())
}
