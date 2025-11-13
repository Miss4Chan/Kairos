//
//  TodayView.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var ctx

    @Query(filter: #Predicate<Task> { $0.isActive == true },
           sort: [SortDescriptor(\Task.createdAt, order: .reverse)])
    private var tasks: [Task]

    // Observe profile so UI auto-updates when XP changes
    @Query private var profiles: [UserProfile]
    private var profile: UserProfile? { profiles.first }

    @StateObject private var vm = TaskListViewModel()

    private var pendingToday: [Task] {
        vm.pendingTasks(from: tasks, ctx: ctx)
    }

    private var leveling: (level: Int, progress: Double, totalXP: Int) {
        let xp = profile?.totalXP ?? 0
        let p = Leveling.progressInLevel(totalXP: xp)
        return (p.level, p.progress, xp)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 5) {
                    TodayHeader(
                        progress: leveling.progress,
                        level: leveling.level,
                        xp: leveling.totalXP
                    )

                    VStack(spacing: 8) {
                        HStack {
                            Text("Today").font(.headline)
                            Spacer()
                            Text("\(pendingToday.count)")
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        
                        if pendingToday.isEmpty {
                            EmptyStateView(
                                title: "You're all caught up!",
                                message: "No pending tasks for today."
                            )
                            .padding(.vertical, 12)
                        } else {
                            ForEach(pendingToday, id: \.id) { task in
                                SwipeToCompleteRow(
                                    task: task,
                                    subtitle: vm.subtitle(for: task),
                                    onComplete: { task in
                                        do {
                                            try vm.complete(task: task, ctx: ctx)
                                        } catch {
                                            // handle error if i want - show toast if not successful? maybe but left for much later not prio now
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Today")
        }
    }
}

#Preview("TodayView") {
    PreviewHarness(root: TodayView())
}
