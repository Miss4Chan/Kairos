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

    @State private var title: String = ""
    @State private var recurrence: RecurrenceType = .daily
    @State private var difficulty: Difficulty = .normal
    @State private var hasTime: Bool = false
    @State private var dueDate: Date = Date()

    var onClose: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)

                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases) { tier in
                            Text(label(for: tier)).tag(tier)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Repeat", selection: $recurrence) {
                        ForEach(RecurrenceType.allCases, id: \.self) { t in
                            Text(t.rawValue.capitalized).tag(t)
                        }
                    }

                    Toggle("Specific time", isOn: $hasTime)

                    DatePicker(
                        hasTime ? "Due" : "Start Date",
                        selection: $dueDate,
                        displayedComponents: hasTime ? [.date, .hourAndMinute] : [.date]
                    )
                }

                Section("Preview") {
                    HStack {
                        Label("\(difficulty.xpReward) XP", systemImage: "sparkles")
                        Spacer()
                        Text(recurrence.rawValue.capitalized)
                            .font(.footnote)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.thinMaterial, in: Capsule())
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close", action: onClose) }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let task = Task(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            notes: nil,
                            recurrence: recurrence,
                            dueDate: dueDate,
                            hasSpecificTime: hasTime,
                            difficulty: difficulty,
                            createdAt: Date(),
                            isActive: true
                        )
                        ctx.insert(task)
                        try? ctx.save()
                        onClose()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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

#Preview("NewTaskSheet") {
    NewTaskSheet { }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .modelContainer(previewContainer)
}
