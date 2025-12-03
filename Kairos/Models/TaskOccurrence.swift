//
//  TaskOccurrence.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation
import SwiftData

//What is the difference between a taks and a task occurance? the task is the template and this is an instance of that task
//This way we keep the task itself and any and all occurances of that task regardless of the type of task
@Model
final class TaskOccurrence {
    @Attribute(.unique) var id: UUID = UUID()
    
    var periodStart: Date
    var periodEnd: Date
    var dueAt: Date
    var completedDate: Date?
    var wasSuccessful: Bool
    var task: UserTask?
    
    //Trying to preserve history using "frozen" snapshots of the task at the given time it was accomplished
    var snapshotTitle: String?
    var snapshotNotes: String?
    var snapshotDifficulty: Difficulty?
    
    init(
        task: UserTask? = nil,
        periodStart: Date,
        periodEnd: Date,
        dueAt: Date,
        completedDate: Date? = nil,
        wasSuccessful: Bool = true
    ) {
        self.task = task
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.dueAt = dueAt
        self.completedDate = completedDate
        self.wasSuccessful = wasSuccessful
    }
}
