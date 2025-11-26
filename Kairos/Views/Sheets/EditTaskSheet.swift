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
    @Bindable var task: Task
    
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
        }
    }
}

#Preview("EditTaskSheet") {
    let context = previewContainer.mainContext
    
    let sample = Task(
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
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
}
