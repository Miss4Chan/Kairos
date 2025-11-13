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
            Form {
                Section("Details") {
                    TextField("Title", text: $task.title)

                    Picker("Difficulty", selection: $task.difficulty) {
                        ForEach(Difficulty.allCases) { t in
                            Text(t.rawValue.capitalized).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Repeat", selection: $task.recurrence) {
                        ForEach(RecurrenceType.allCases, id: \.self) { r in
                            Text(r.rawValue.capitalized).tag(r)
                        }
                    }

                    Toggle("Specific time", isOn: $task.hasSpecificTime)

                    DatePicker(
                        task.hasSpecificTime ? "Due" : "Date",
                        selection: Binding(
                            get: { task.dueDate ?? Date() },
                            set: { task.dueDate = $0 }
                        ),
                        displayedComponents: task.hasSpecificTime ? [.date, .hourAndMinute] : [.date]
                    )
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { try? ctx.save(); dismiss() }
                        .disabled(task.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
