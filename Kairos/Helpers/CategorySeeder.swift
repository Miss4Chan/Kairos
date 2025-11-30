//
//  CategorySeeder.swift
//  Kairos
//
//  Created by Despina Misheva on 27.11.25.
//


import Foundation
import SwiftData

struct CategorySeeder {
    
    static func seedDefaultsIfNeeded(modelContext: ModelContext) {
        //Fetch and check if they already exist so no need to create them twice!
        let fetch = FetchDescriptor<Category>()
        
        if let count = try? modelContext.fetch(fetch).count, count == 0 {
            let home = Category(
                name: "Home",
                colorHex: "#6AA84F",
                iconName: "house.fill"
            )
            
            let work = Category(
                name: "Work",
                colorHex: "#3D85C6",
                iconName: "briefcase.fill"
            )
            
            let school = Category(
                name: "School",
                colorHex: "#E69138",
                iconName: "book.closed.fill"
            )
            
            modelContext.insert(home)
            modelContext.insert(work)
            modelContext.insert(school)
            
            try? modelContext.save()
            print("Seeded the default categories")
        }
    }
}
