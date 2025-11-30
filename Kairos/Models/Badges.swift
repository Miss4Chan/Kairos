//
//  Badges.swift
//  Kairos
//
//  Created by Despina Misheva on 30.11.25.
//

import Foundation

struct Badge: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let unlockLevel: Int
}

enum BadgeCatalog {
    static let all: [Badge] = [
        Badge(
            name: "Newcomer",
            description: "Reached level 1",
            iconName: "star",
            unlockLevel: 1
        ),
        Badge(
            name: "Apprentice",
            description: "Reached level 5",
            iconName: "star.lefthalf.fill",
            unlockLevel: 15
        ),
        Badge(
            name: "Achiever",
            description: "Reached level 10",
            iconName: "star.fill",
            unlockLevel: 30
        ),
        Badge(
            name: "Specialist",
            description: "Reached level 20",
            iconName: "rosette",
            unlockLevel: 50
        ),
        Badge(
            name: "Master",
            description: "Reached level 30",
            iconName: "crown.fill",
            unlockLevel: 100
        )
    ]
    
    static func currentBadge(forLevel level: Int) -> Badge? {
        all
            .sorted { $0.unlockLevel < $1.unlockLevel }
            .last(where: { level >= $0.unlockLevel })
    }
    
    static func nextBadge(forLevel level: Int) -> Badge? {
        all
            .sorted { $0.unlockLevel < $1.unlockLevel }
            .first(where: { level < $0.unlockLevel })
    }
}
