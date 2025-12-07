//
//  KairosApp.swift
//  Kairos
//
//  Created by Despina Misheva on 6.11.25.
//

import SwiftUI
import SwiftData

///This is the main entry for this app - App keyword is a protocol that is the SwiftUIs lifecycle
@main
struct KairosApp: App {
    ///Appstorage it persist the values into the UserDefaults automatically and keep the swiftui synced with it
    ///Its basically like a key-value pair so for the key appTheme we store the value
    @AppStorage("appTheme") private var appThemeRawValue: String = AppTheme.system.rawValue

    ///since we wanna apply them everywhere we keep em globally
    ///this here is a computed property which reverts to system in case this value is missing
    private var appTheme: AppTheme {
        AppTheme(rawValue: appThemeRawValue) ?? .system
    }
    
    ///This is the model container which is kinda like the database + the schema all in one
    ///here we create the obj and assign a folder as well as the schema and config to it
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            UserTask.self,
            TaskOccurrence.self,
            Category.self
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
        ///we inject the model container into the environment so all views can use the swiftdata functionalities (such as query)
    }
}
