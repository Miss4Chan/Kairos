//
//  TasksView.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Environment(\.modelContext) private var ctx
    @Query(
        filter: #Predicate<UserTask> { $0.isActive == true },
        sort: [SortDescriptor(\UserTask.createdAt, order: .reverse)]
    )
    private var tasks: [UserTask]
    
    @State private var editMode: EditMode = .inactive
    
    @State private var showNewTaskSheet = false
    @State private var editingTask: UserTask?
    
    var body: some View {
        NavigationStack {
            let isEditing = editMode != .inactive
            
            List {
                if tasks.isEmpty {
                    EmptyStateView(
                        title: "No tasks yet",
                        message: "Tap the plus to create your first task."
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(tasks) { task in
                        TaskRowCell(
                            task: task,
                            isEditing: isEditing,
                            onTap: { editingTask = task }
                        )
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            //ctx.delete(tasks[index])
                            tasks[index].isActive = false
                        }
                        try? ctx.save()
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .font(.title3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewTaskSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: editMode)
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $showNewTaskSheet) {
                NewTaskSheet { showNewTaskSheet = false }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $editingTask) { task in
                EditTaskSheet(task: task)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .onDisappear {
                        editMode = .inactive
                    }
            }
        }
    }
}

#Preview("TasksView") {
    PreviewHarness(root: TasksView())
}

