//
//  RecurrenceType.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation

enum RecurrenceType: String, Codable, CaseIterable {
    case daily
    case weekly
    case biWeekly
    case monthly
    case biMonthly
    case none
}

extension RecurrenceType {
    var displayName: String {
        switch self {
        case .none:      return "One-time"
        case .daily:     return "Daily"
        case .weekly:    return "Weekly"
        case .biWeekly:  return "Every 2 weeks"
        case .monthly:   return "Monthly"
        case .biMonthly: return "Every 2 months"
        }
    }
}
