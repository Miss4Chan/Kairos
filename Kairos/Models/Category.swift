//
//  Category.swift
//  Kairos
//
//  Created by Despina Misheva on 27.11.25.
//


import Foundation
import SwiftData

@Model
class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorHex: String
    var iconName: String?

    init(name: String, colorHex: String, iconName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
    }
}

