//
//  EditTaskSheet.swift
//  Kairos
//
//  Created by Despina Misheva on 12.11.25.
//

import SwiftUI
import SwiftData

struct EditTaskSheet: View {
    @Environment(\.modelContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    
    /// Makes a SwiftData @Model object’s properties bindable in SwiftUI  so we can read/write
    /// Basically it turns a model object into a form-friendly thing and it auto-generates the get,set for its fields - we need this in the form to make changes directly to something that is kept as a model object
    @Bindable var task: UserTask
    @State private var selectedCategory: Category?
    
    
    var body: some View {
        NavigationStack {
            TaskFormView(
                title: $task.title,
                recurrence: $task.recurrence,
                difficulty: $task.difficulty,
                hasSpecificTime: $task.hasSpecificTime,
                date: Binding(
                    get: { task.dueDate ?? Date() },
                    set: { task.dueDate = $0 }
                ),
                selectedCategory: $task.category,
                dateLabelWhenTimed: "Due",
                dateLabelWhenNotTimed: "Date"
            )
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        try? ctx.save()
                        dismiss()
                    }
                    .disabled(task.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                if selectedCategory == nil {
                    selectedCategory = task.category
                }
            }
        }
    }
}
#Preview("EditTaskSheet") {
    let context = previewContainer.mainContext
    
    let sample = UserTask(
        title: "Sample Task",
        notes: "Preview",
        recurrence: .daily,
        dueDate: Date(),
        hasSpecificTime: false,
        difficulty: .normal,
        createdAt: Date(),
        isActive: true
    )
    
    context.insert(sample)
    
    return EditTaskSheet(task: sample)
        .environment(\.modelContext, context)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}
