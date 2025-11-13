//
//  TaskListViewModel.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation
import SwiftData

//This is our VM and its different from the service even though it shares similar functions
//He doesnt own the truth just delegates the service and acts as the glue that is between the stored data and the ui components
//He gets action from the ui and says to the service "please complete this and tell me what i should update in my views"
@MainActor //This means that its a singleton - it will be initialized once upon creaton and does not get recreated for every other call
final class TaskListViewModel: ObservableObject {
    func subtitle(for task: Task,
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

        case .monthly:
            if let due = task.dueDate, (start...end).contains(due), task.hasSpecificTime {
                return df.string(from: due)
            }
            return "Due end of month (\(df.string(from: end)))"

        case .none:
            if let due = task.dueDate {
                return df.string(from: due)
            }
            return "No due date"
        }
    }
    
    func isCompletedForCurrentPeriod(_ task: Task,
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
    
    
    func pendingTasks(from tasks: [Task],
                      ctx: ModelContext,
                      reference: Date = Date(),
                      calendar: Calendar = Calendar(identifier: .iso8601)) -> [Task] {
        tasks.filter { task in
            !isCompletedForCurrentPeriod(task, ctx: ctx, reference: reference, calendar: calendar)
        }
    }
    
    func complete(task: Task, ctx: ModelContext) throws {
        let occ = try SchedulingService.ensureOccurrence(for: task, ctx: ctx)
        
        guard occ.completedDate == nil else { return }
        
        try SchedulingService.complete(occ, ctx: ctx)
        
        if task.recurrence == .none {
            task.isActive = false
            try ctx.save()
        }
    }
}
