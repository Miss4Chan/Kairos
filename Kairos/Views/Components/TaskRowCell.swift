//
//  TaskRowCell.swift
//  Kairos
//
//  Created by Despina Misheva on 12.11.25.
//
import SwiftUI
import SwiftData
struct TaskRowCell: View {
    let task: Task
    let isEditing: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .fontWeight(.semibold)

                HStack(spacing: 8) {
                    Text(task.recurrence.rawValue.capitalized)
                        .capsuleTag()

                    let xp = task.difficulty.xpReward
                    if xp > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "bolt").imageScale(.small)
                            Text("\(xp)")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
            if isEditing {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { if isEditing { onTap() } }
        .padding(8)
        .accessibilityAddTraits(isEditing ? .isButton : [])
    }
}

#Preview {
    struct Wrap: View {
        let task = Task(title: "Pay bills", recurrence: .weekly, difficulty: .normal)
        var body: some View {
            List {
                TaskRowCell(task: task, isEditing: true, onTap: {})
            }
        }
    }
    return Wrap()
}
