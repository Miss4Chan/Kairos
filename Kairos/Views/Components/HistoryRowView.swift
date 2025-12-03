//
//  HistoryRowView.swift
//  Kairos
//
//  Created by Despina Misheva on 3.12.25.
//

import SwiftUI

struct HistoryRowView: View {
    let occ: TaskOccurrence
    let title: String
    let xp: Int?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .imageScale(.large)
                .foregroundStyle(.green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    if let when = occ.completedDate {
                        Text(DateFormats.timeShort.string(from: when))
                            .foregroundStyle(.secondary)
                    }
                    
                    if let xp {
                        HStack(spacing: 3) {
                            Image(systemName: "bolt")
                                .imageScale(.small)
                            Text("\(xp)")
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    if let category = occ.task?.category {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: category.colorHex))
                                .frame(width: 8, height: 8)
                            
                            if let icon = category.iconName, !icon.isEmpty {
                                Image(systemName: icon).imageScale(.small)
                            }
                            
                            Text(category.name)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                .font(.subheadline)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


#Preview("HistoryRowView") {
    let ctx = previewContainer.mainContext

    let cat = Category(name: "Work", colorHex: "#3D85C6", iconName: "briefcase.fill")
    ctx.insert(cat)

    let task = UserTask(title: "Ship feature", recurrence: .daily)
    task.category = cat
    ctx.insert(task)

    let occ = TaskOccurrence(
        task: task,
        periodStart: Date().addingTimeInterval(-3600),
        periodEnd: Date(),
        dueAt: Date(),
        completedDate: Date(),
        wasSuccessful: true
    )
    occ.snapshotTitle = "Ship feature"
    occ.snapshotDifficulty = task.difficulty
    ctx.insert(occ)

    return List {
        HistoryRowView(occ: occ, title: "Ship feature", xp: 20)
    }
    .modelContainer(previewContainer)
}
