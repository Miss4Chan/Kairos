//
//  SettingsView.swift
//  Kairos
//
//  Created by Despina Misheva on 27.11.25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $appTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Tasks") {
                    NavigationLink("Manage categories") {
                        CategoriesSettingsView()
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .task {
            CategorySeeder.seedDefaultsIfNeeded(modelContext: modelContext)
        }
    }
    
}

#Preview {
    SettingsView()
}

