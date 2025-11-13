//
//  Difficulty.swift
//  Kairos
//
//  Created by Despina Misheva on 11.11.25.
//

import Foundation

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case trivial, easy, normal, hard, brutal
    var id: String { rawValue }

    /// XP rewards for each level of difficulty. User should just pick the level they think the task is since the system is trust based
    var xpReward: Int {
        switch self {
        case .trivial: return 10
        case .easy:    return 25
        case .normal:  return 50
        case .hard:    return 100
        case .brutal:  return 200
        }
    }
}
