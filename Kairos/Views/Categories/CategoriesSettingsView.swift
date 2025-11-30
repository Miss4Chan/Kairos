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
                    CategoryRowView(
                        category: category,
                        showsChevron: isEditing,
                        usedCount: taskCount(for: category)
                    )
                    .onTapGesture {
                        if isEditing {
                            startEditing(category)
                        }
                    }
                }
                //We need to safe delete the categories and make sure that we assign the tasks with no category if the cat is deleted
                //Don't try without this - I broke my DB and had to recreate everything :((((( r.i.p my history
                .onDelete { indexSet in
                    for index in indexSet {
                        let category = categories[index]
                        let categoryID = category.id
                        
                        let fetch = FetchDescriptor<Task>(
                            predicate: #Predicate<Task> { task in
                                task.category?.id == categoryID
                            }
                        )
                        
                        if let tasksUsingCategory = try? modelContext.fetch(fetch) {
                            for task in tasksUsingCategory {
                                task.category = nil
                            }
                        }
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
                CategoryFormView(
                    name: $newName,
                    iconName: $newIconName,
                    selectedColor: $selectedColor,
                    suggestedSymbols: suggestedSymbols
                )
                .navigationTitle(editingCategory == nil ? "New Category" : "Edit Category")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            isPresentingCategorySheet = false
                            resetForm()
                            editingCategory = nil
                            editMode = .inactive
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
    
    private func taskCount(for category: Category) -> Int {
        let categoryID = category.id
        
        let fetch = FetchDescriptor<Task>(
            predicate: #Predicate<Task> { task in
                task.category?.id == categoryID
            }
        )
        
        do {
            let tasksUsingCategory = try modelContext.fetch(fetch)
            return tasksUsingCategory.count
        } catch {
            return 0
        }
    }
    
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
        editMode = .inactive
    }
}

#Preview {
    NavigationStack {
        CategoriesSettingsView()
    }
    .modelContainer(for: Category.self, inMemory: true)
}
