//
//  CategoriesSettingsView.swift
//  Kairos
//
//  Created by Despina Misheva on 27.11.25.
//

import SwiftUI
import SwiftData
import UIKit

struct CategoriesSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.name) private var categories: [Category]
    
    @State private var editMode: EditMode = .inactive
    
    @State private var isPresentingCategorySheet = false
    @State private var editingCategory: Category? = nil
    
    // Needed for the sheet
    @State private var newName: String = ""
    @State private var newIconName: String = ""
    @State private var selectedColor: Color = Color(hex: "#3D85C6")
    
    // Suggested icons for quick picking -- there is a package I found that i can use here
    //https://github.com/xnth97/SymbolPicker?ref=iosexample.com
    //Will give it a go at some point
    
    private let suggestedSymbols: [String] = [
        "house.fill",
        "briefcase.fill",
        "book.closed.fill",
        "cart.fill",
        "heart.fill",
        "star.fill",
        "folder.fill",
        "checkmark.circle.fill",
        "clock.fill"
    ]
    
    var body: some View {
        let isEditing = editMode != .inactive
        
        List {
            if categories.isEmpty {
                Text("No categories yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(categories) { category in
                    HStack(spacing: 12) {
                        if let iconName = category.iconName, !iconName.isEmpty {
                            Image(systemName: iconName)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.name)
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: category.colorHex))
                                    .frame(width: 10, height: 10)
                                if let iconName = category.iconName, !iconName.isEmpty {
                                    Text(iconName)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if isEditing {
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isEditing {
                            startEditing(category)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let category = categories[index]
                        modelContext.delete(category)
                    }
                    try? modelContext.save()
                }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                EditButton()
                Button {
                    startAddingCategory()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: $isPresentingCategorySheet) {
            NavigationStack {
                Form {
                    Section("Name") {
                        TextField("Category name", text: $newName)
                    }
                    
                    Section("Icon") {
                        let columns = [GridItem(.adaptive(minimum: 40))]
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(suggestedSymbols, id: \.self) { symbol in
                                Button {
                                    newIconName = symbol
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                newIconName == symbol ? Color.accentColor : Color.secondary.opacity(0.3),
                                                lineWidth: newIconName == symbol ? 2 : 1
                                            )
                                            .frame(width: 40, height: 40)
                                        Image(systemName: symbol)
                                            .font(.system(size: 18))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        TextField("Custom SF Symbol name (optional)", text: $newIconName)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        if !newIconName.isEmpty {
                            HStack(spacing: 8) {
                                Text("Preview:")
                                Image(systemName: newIconName)
                            }
                            .font(.caption)
                        }
                        
                        Text("Tap an icon above or enter any valid SF Symbol name.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Section("Color") {
                        ColorPicker("Category color", selection: $selectedColor, supportsOpacity: false)
                    }
                }
                .navigationTitle(editingCategory == nil ? "New Category" : "Edit Category")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            isPresentingCategorySheet = false
                            resetForm()
                            editingCategory = nil
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            saveCategory()
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func startAddingCategory() {
        editingCategory = nil
        resetForm()
        isPresentingCategorySheet = true
    }
    
    private func startEditing(_ category: Category) {
        editingCategory = category
        newName = category.name
        newIconName = category.iconName ?? ""
        selectedColor = Color(hex: category.colorHex)
        isPresentingCategorySheet = true
    }
    
    private func resetForm() {
        newName = ""
        newIconName = ""
        selectedColor = Color(hex: "#3D85C6")
    }
    
    private func saveCategory() {
        let trimmedName = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let icon = newIconName.trimmingCharacters(in: .whitespaces)
        let iconToStore = icon.isEmpty ? nil : icon
        
        let hexToStore = selectedColor.toHex() ?? "#3D85C6"
        
        if let editing = editingCategory {
            editing.name = trimmedName
            editing.colorHex = hexToStore
            editing.iconName = iconToStore
        } else {
            let category = Category(
                name: trimmedName,
                colorHex: hexToStore,
                iconName: iconToStore
            )
            modelContext.insert(category)
        }
        
        try? modelContext.save()
        
        resetForm()
        editingCategory = nil
        isPresentingCategorySheet = false
    }
}

#Preview {
    NavigationStack {
        CategoriesSettingsView()
    }
    .modelContainer(for: Category.self, inMemory: true)
}

private struct ColorChoiceCircle: View {
    let title: String
    let hex: String
    @Binding var selectedHex: String
    
    var body: some View {
        Button {
            selectedHex = hex
        } label: {
            VStack {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 24, height: 24)
                    .overlay {
                        if selectedHex == hex {
                            Circle()
                                .strokeBorder(.primary, lineWidth: 2)
                        }
                    }
                
                Text(title)
                    .font(.caption2)
            }
        }
        .buttonStyle(.plain)
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 8: // ARGB
            a = (int & 0xFF000000) >> 24
            r = (int & 0x00FF0000) >> 16
            g = (int & 0x0000FF00) >> 8
            b = int & 0x000000FF
        case 6: // RGB
            a = 255
            r = (int & 0xFF0000) >> 16
            g = (int & 0x00FF00) >> 8
            b = int & 0x0000FF
        default:
            a = 255
            r = 0
            g = 0
            b = 0
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    //TODO: Explain this later
    func toHex() -> String? {
#if canImport(UIKit)
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let ri = Int(round(r * 255))
        let gi = Int(round(g * 255))
        let bi = Int(round(b * 255))
        
        return String(format: "#%02X%02X%02X", ri, gi, bi)
#else
        return nil
#endif
    }
}
