//
//  TaskListViewModel.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation
import SwiftData

///This is our VM and its different from the service even though it shares similar functions
///He doesnt own the truth just delegates the service and acts as the glue that is between the stored data and the ui components
///He gets action from the ui and says to the service "please complete this and tell me what i should update in my views"
@MainActor ///This means that this types methods run on the main thread
///Observable object is a type of object with a publisher that emits before the object has changes and its an observation mechanism
final class TaskListViewModel: ObservableObject {
    /// One-shot UI trigger for rewards (meme popup)
    /// SwiftData changes (occurrence completed / XP updated) refresh views, but they don't reliably mean
    /// “show a reward exactly once right now”, this published event lets the UI present the meme once
    /// per completion, without tying the popup to persisted state.
    /// This I use in the onChage inside the todayview basically to trigger view updates, its kinda like an observable flag
    @Published var completionEventID: UUID?
    
    
    /// Returns a human-friendly subtitle for a task in the given reference period (eg. "Today", "Due end of week ..")
    func subtitle(for task: UserTask,
                  reference: Date = Date(),
                  calendar: Calendar = Calendar(identifier: .iso8601)) -> String {
        let (start, end) = task.periodBounds(for: reference, calendar: calendar)
        let df = task.hasSpecificTime ? DateFormats.dateTimeMediumShort : DateFormats.dateOnlyMedium
        
        switch task.recurrence {
        case .daily:
            if let due = task.dueDate, (start...end).contains(due), task.hasSpecificTime {
                return df.string(from: due)
            }
            return "Today"
            
        case .weekly:
            if let due = task.dueDate, (start...end).contains(due), task.hasSpecificTime {
                return df.string(from: due)
            }
            return "Due end of week (\(df.string(from: end)))"
            
        case .biWeekly:
            if let due = task.dueDate, (start...end).contains(due), task.hasSpecificTime {
                return df.string(from: due)
            }
            return "Due end of 2-week period (\(df.string(from: end)))"
            
            
        case .monthly:
            if let due = task.dueDate, (start...end).contains(due), task.hasSpecificTime {
                return df.string(from: due)
            }
            return "Due end of month (\(df.string(from: end)))"
            
        case .biMonthly:
            if let due = task.dueDate, (start...end).contains(due), task.hasSpecificTime {
                return df.string(from: due)
            }
            return "Due end of 2-month period (\(df.string(from: end)))"
            
        case .none:
            if let due = task.dueDate {
                return df.string(from: due)
            }
            return "No due date"
        }
    }
    
    /// Returns whether the task has been completed for the current recurrence period
    func isCompletedForCurrentPeriod(_ task: UserTask,
                                     ctx: ModelContext,
                                     reference: Date = Date(),
                                     calendar: Calendar = Calendar(identifier: .iso8601)) -> Bool {
        do {
            let occ = try SchedulingService.ensureOccurrence(
                for: task,
                reference: reference,
                calendar: calendar,
                ctx: ctx
            )
            return occ.completedDate != nil
        } catch {
            return false
        }
    }
    
    /// Filters the provided tasks down to those not completed in the current period
    func pendingTasks(from tasks: [UserTask],
                      ctx: ModelContext,
                      reference: Date = Date(),
                      calendar: Calendar = Calendar(identifier: .iso8601)) -> [UserTask] {
        tasks.filter { task in
            !isCompletedForCurrentPeriod(task, ctx: ctx, reference: reference, calendar: calendar)
        }
    }
    
    /// Marks the tasks current-period occurrence as complete and persists changes
    /// Triggers completionEventID so the UI can show a one-time reward

    func complete(task: UserTask, ctx: ModelContext) throws {
        let occ = try SchedulingService.ensureOccurrence(for: task, ctx: ctx)
        
        guard occ.completedDate == nil else { return }
        
        try SchedulingService.complete(occ, ctx: ctx)
        
        if task.recurrence == .none {
            task.isActive = false
            try ctx.save()
        }
        
        completionEventID = UUID()
    }
}
