//
//  PreviewHarness.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI
import SwiftData

struct PreviewHarness<Content: View>: View {
    let root: Content
    var body: some View {
        root.modelContainer(previewContainer)
    }
}

//Think of this as a mock up or test in other frameworks - u need to initialize and inject all necessary data to be able to create a mock up
@MainActor
let previewContainer: ModelContainer = {
    do {
        let schema = Schema([UserProfile.self, UserTask.self, TaskOccurrence.self, Category.self])
        let conf = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [conf])
        let ctx = ModelContext(container)
        if (try? ctx.fetch(FetchDescriptor<UserTask>()))?.isEmpty ?? true {
            let t1 = UserTask(title: "Brush teeth", recurrence: .daily)
            let t2 = UserTask(title: "Pay bills",  recurrence: .weekly)
            let t3 = UserTask(title: "Clean fridge", recurrence: .monthly)
            let t4 = UserTask(title: "Call mom",
                          recurrence: .none,
                          dueDate: Date().addingTimeInterval(3600),
                          hasSpecificTime: true)
            ctx.insert(t1); ctx.insert(t2); ctx.insert(t3); ctx.insert(t4)
            try? ctx.save()
        }
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
