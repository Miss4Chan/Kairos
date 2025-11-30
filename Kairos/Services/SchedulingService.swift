//
//  SchedulingService.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation
import SwiftData

// What is the service here? - Its our source of truth since its the only one that can directly manipulate the data in the store
//It takes care of how the data changes and writes and saves in the db
//It is stateless basically an enum with just static functions
enum SchedulingService {
    @discardableResult
    static func ensureOccurrence(
        for task: Task,
        reference: Date = Date(),
        calendar: Calendar = Calendar(identifier: .iso8601),
        ctx: ModelContext
    ) throws -> TaskOccurrence {
        
        let (start, end) = task.periodBounds(for: reference, calendar: calendar)
        let due = task.dueInCurrentPeriod(reference: reference, calendar: calendar)
        
        if let existing = task.occurrences.first(where: { $0.periodStart == start && $0.periodEnd == end }) {
            return existing
        }
        
        let occ = TaskOccurrence(
            task: task,
            periodStart: start,
            periodEnd: end,
            dueAt: due,
            completedDate: nil,
            wasSuccessful: true
        )
        ctx.insert(occ)
        try ctx.save()
        return occ
    }
    
    static func complete(_ occ: TaskOccurrence, at date: Date = Date(), ctx: ModelContext) throws {
        guard occ.completedDate == nil else { return }
        occ.completedDate = date
        
        if occ.snapshotTitle == nil {
            occ.snapshotTitle = occ.task?.title
            occ.snapshotNotes = occ.task?.notes
            occ.snapshotDifficulty = occ.task?.difficulty
        }
        
        var profile = try ctx.fetch(FetchDescriptor<UserProfile>()).first
        if profile == nil {
            let p = UserProfile(name: "Local Tester", totalXP: 0)
            ctx.insert(p); profile = p
        }
        if let xp = occ.task?.difficulty.xpReward {
            profile!.totalXP += xp
        }
        try ctx.save()
    }
    
    static func undo(
        _ occ: TaskOccurrence,
        ctx: ModelContext,
        calendar: Calendar = Calendar(identifier: .iso8601)
    ) throws {
        guard let completedAt = occ.completedDate else { return }
        
        
        var profile = try ctx.fetch(FetchDescriptor<UserProfile>()).first
        if profile == nil {
            let p = UserProfile(name: "Local Tester", totalXP: 0)
            ctx.insert(p); profile = p
        }
        
        if let task = occ.task,
           let xp = task.difficulty.xpReward as Int? {
            let current = profile?.totalXP ?? 0
            profile?.totalXP = max(0, current - xp)
        }
        
        if let task = occ.task, task.recurrence == .none {
            task.isActive = true
        }
        
        occ.completedDate = nil
        occ.snapshotTitle = nil
        occ.snapshotNotes = nil
        occ.snapshotDifficulty = nil
        
        try ctx.save()
    }
}
