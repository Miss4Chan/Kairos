//
//  KairosApp.swift
//  Kairos
//
//  Created by Despina Misheva on 6.11.25.
//

import SwiftUI
import SwiftData

@main
struct KairosApp: App {
    @AppStorage("appTheme") private var appThemeRawValue: String = AppTheme.system.rawValue

    private var appTheme: AppTheme {
        AppTheme(rawValue: appThemeRawValue) ?? .system
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            Task.self,
            TaskOccurrence.self
        ])

        let fm = FileManager.default
        if let appSupport = try? fm.url(for: .applicationSupportDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: true) {
            let storeFolder = appSupport.appendingPathComponent("Kairos", isDirectory: true)
            try? fm.createDirectory(at: storeFolder, withIntermediateDirectories: true)
        }

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()


    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(appTheme.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}
