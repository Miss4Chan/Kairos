//
//  HistoryView.swift
//  Kairos
//
//  Created by Despina Misheva on 11.11.25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(
        filter: #Predicate<TaskOccurrence> { $0.completedDate != nil },
        sort: [SortDescriptor(\TaskOccurrence.completedDate, order: .reverse)]
    )
    private var completed: [TaskOccurrence]
    
    private var sortedDays: [Date] {
        Array(groupedByDay.keys).sorted(by: >)
    }
    
    private func items(on day: Date) -> [TaskOccurrence] {
        groupedByDay[day] ?? []
    }
    
    
    var body: some View {
        NavigationStack {
            if completed.isEmpty {
                ScrollView {
                    VStack(spacing: 24) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                        Text("No history yet").font(.title3.weight(.semibold))
                        Text("Your completed tasks will appear here.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 64)
                }
                .navigationTitle("History")
            } else {
                List {
                    ForEach(sortedDays, id: \.self) { day in
                        Section(DateFormats.dayMedium.string(from: day)) {
                            ForEach(items(on: day), id: \.id) { occ in
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .imageScale(.large)
                                        .foregroundStyle(.green)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(title(for: occ))
                                            .font(.headline)
                                        HStack(spacing: 8) {
                                            if let when = occ.completedDate {
                                                Text(DateFormats.timeShort.string(from: when))
                                                    .foregroundStyle(.secondary)
                                            }
                                            if let xp = xp(for: occ) {
                                                Label("\(xp)", systemImage: "bolt")
                                                    .labelStyle(.titleAndIcon)
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
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("History")
            }
        }
    }
    
    private var groupedByDay: [Date: [TaskOccurrence]] {
        let cal = Calendar(identifier: .iso8601)
        return Dictionary(grouping: completed) { occ in
            let when = occ.completedDate ?? .distantPast
            return cal.startOfDay(for: when)
        }
    }
    
    private func title(for occ: TaskOccurrence) -> String {
        occ.snapshotTitle ?? occ.task?.title ?? "Task"
    }
    
    private func xp(for occ: TaskOccurrence) -> Int? {
        let difficulty = occ.snapshotDifficulty ?? occ.task?.difficulty
        guard let xp = difficulty?.xpReward, xp > 0 else { return nil }
        return xp
    }
    
}
