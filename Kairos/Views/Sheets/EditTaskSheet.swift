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
                        ForEach(Difficulty.allCases) { tier in
                            Text("\(label(for: tier))  (\(tier.xpReward) XP)")
                                .tag(tier)
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
                Section("Preview") {
                    HStack {
                        Label("\(task.difficulty.xpReward) XP", systemImage: "sparkles")
                        Spacer()
                        Text(task.recurrence.rawValue.capitalized)
                            .font(.footnote)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.thinMaterial, in: Capsule())
                    }
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
    private func label(for tier: Difficulty) -> String {
        switch tier {
        case .trivial: return "Trivial"
        case .easy:    return "Easy"
        case .normal:  return "Normal"
        case .hard:    return "Hard"
        case .brutal:  return "Brutal"
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
