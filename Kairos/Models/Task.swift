//
//  Task.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation
import SwiftData

@Model
final class Task {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var notes: String?
    var recurrence: RecurrenceType
    var dueDate: Date?
    var hasSpecificTime: Bool
    var difficulty: Difficulty
    var createdAt: Date
    var isActive: Bool
    
    //Changed it to noAction and added snapshot fields in the TaskOccurrence
    @Relationship(deleteRule: .noAction, inverse: \TaskOccurrence.task)
    var occurrences: [TaskOccurrence] = []
    
    var category: Category?
    
    init(
        title: String,
        notes: String? = nil,
        recurrence: RecurrenceType,
        dueDate: Date? = nil,
        hasSpecificTime: Bool = false,
        difficulty: Difficulty = .normal,
        createdAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.title = title
        self.notes = notes
        self.recurrence = recurrence
        self.dueDate = dueDate
        self.hasSpecificTime = hasSpecificTime
        self.difficulty = difficulty
        self.createdAt = createdAt
        self.isActive = isActive
    }
}

// MARK: - These are some functions that take care of the state transition and making sure that the start and ends are correctly caulcated depening on the type
extension Task {
    func periodBounds(for reference: Date, calendar: Calendar = Calendar(identifier: .iso8601)) -> (start: Date, end: Date) {
        switch recurrence {
        case .daily:
            let start = calendar.startOfDay(for: reference)
            let end = calendar.date(byAdding: .day, value: 1, to: start)!.addingTimeInterval(-1)
            return (start, end)
        case .weekly:
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: reference))!
            let end = calendar.date(byAdding: .day, value: 7, to: start)!.addingTimeInterval(-1)
            return (start, end)
        case .biWeekly:
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: reference))!
            let end = calendar.date(byAdding: .day, value: 14, to: start)!.addingTimeInterval(-1)
            return (start, end)
        case .monthly:
            let comps = calendar.dateComponents([.year, .month], from: reference)
            let start = calendar.date(from: comps)!
            let end = calendar.date(byAdding: .month, value: 1, to: start)!.addingTimeInterval(-1)
            return (start, end)
        case .biMonthly:
            let comps = calendar.dateComponents([.year, .month], from: reference)
            let start = calendar.date(from: comps)!
            let end = calendar.date(byAdding: .month, value: 2, to: start)!.addingTimeInterval(-1)
            return (start, end)
        case .none:
            let start = calendar.startOfDay(for: reference)
            let end = calendar.date(byAdding: .day, value: 1, to: start)!.addingTimeInterval(-1)
            return (start, end)
        }
    }
    
    func dueInCurrentPeriod(reference: Date = Date(), calendar: Calendar = Calendar(identifier: .iso8601)) -> Date {
        let (start, end) = periodBounds(for: reference, calendar: calendar)
        
        if let due = dueDate, (start...end).contains(due) {
            if hasSpecificTime { return due }
            return calendar.startOfDay(for: due)
        }
        return end
    }
}
