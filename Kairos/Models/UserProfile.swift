//
//  UserProfile.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var totalXP: Int

    init(name: String, totalXP: Int = 0) {
        self.name = name
        self.totalXP = totalXP
    }
}
