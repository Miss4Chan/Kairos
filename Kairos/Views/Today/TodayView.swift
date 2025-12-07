//
//  TodayView.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    ///This is the swift data context and it allows for reading and writing into the models
    ///This is basically a depndency injection but we read it from the SwiftUI Environment
    ///Using environment we do an environment value look up inside of the modelContext that was passed higher in the tree (KairosApp.swift)
    ///How can we understand the context? As any other context its basically a staging area where all the insert/delete/update happen before it gets saved, feels like a transaction
    @Environment(\.modelContext) private var ctx

    ///Live query that feeds into an "observable" for the active tasks, in case they change auto update
    @Query(filter: #Predicate<UserTask> { $0.isActive == true },
           sort: [SortDescriptor(\UserTask.createdAt, order: .reverse)])
    private var tasks: [UserTask]

    /// Observe profile so UI auto-updates when XP changes
    @Query private var profiles: [UserProfile]
    private var profile: UserProfile? { profiles.first }

    ///This is our view model which gets created here kinda like one instance of the vm owned by this view instance 
    ///Its a state object since it conforms to observable object
    @StateObject private var vm = TaskListViewModel()
    
    ///State is a property wrapper which read/writes a swiftui value and its local view owned
    @State private var memeToShow: Meme?

    private var pendingToday: [UserTask] {
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
                                            ///TODO?
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
            ///Sets the title displayed in a navigation bar
            .navigationTitle("Today")
            /// basically on change runs a side effect when a value changes 
            .onChange(of: vm.completionEventID) {
                guard vm.completionEventID != nil else { return }
                ///Cursed be I had to rename my class for this ahahahaha
                /// It a task a unit of async work and it can be awaited or chancelled (we await the fetch for the meme as it has async for getting the image)
                Task {
                    memeToShow = await MemeService.fetchWholesomeMeme()
                    vm.completionEventID = nil //kill it
                }
            }
            ///Modal sheet with an item - it can open forms/editors/settings modally
            .sheet(item: $memeToShow) { meme in
                MemeRewardView(meme: meme)
                /// This controls the sheet height 
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview("TodayView") {
    PreviewHarness(root: TodayView())
}
