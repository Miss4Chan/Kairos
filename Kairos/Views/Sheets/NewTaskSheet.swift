//
//  NewTaskSheet.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI
import SwiftData

struct NewTaskSheet: View {
    @Environment(\.modelContext) private var ctx
    
    ///State is the owner the source of truth
    @State private var title: String = ""
    @State private var recurrence: RecurrenceType = .daily
    @State private var difficulty: Difficulty = .normal
    @State private var hasTime: Bool = false
    @State private var dueDate: Date = Date()
    @State private var selectedCategory: Category? = nil
    
    
    var onClose: () -> Void
    
    /// In here the $something is a binding that is created from the @State
    var body: some View {
        NavigationStack {
            TaskFormView(
                title: $title,
                recurrence: $recurrence,
                difficulty: $difficulty,
                hasSpecificTime: $hasTime,
                date: $dueDate,
                selectedCategory: $selectedCategory, dateLabelWhenTimed: "Due",
                dateLabelWhenNotTimed: "Start Date",
            )
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", action: onClose)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let task = UserTask(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            notes: nil,
                            recurrence: recurrence,
                            dueDate: dueDate,
                            hasSpecificTime: hasTime,
                            difficulty: difficulty,
                            createdAt: Date(),
                            isActive: true
                        )
                        task.category = selectedCategory
                        ctx.insert(task)
                        try? ctx.save()
                        onClose()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}


#Preview("NewTaskSheet") {
    NewTaskSheet { }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .modelContainer(previewContainer)
}
