//
//  SettingsView.swift
//  Kairos
//
//  Created by Despina Misheva on 27.11.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system

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
    }
}

//Take this into another file when it actually contains some logic
struct CategoriesSettingsView: View {
    var body: some View {
        Text("Categories screen coming soon")
            .navigationTitle("Categories")
    }
}

#Preview {
    SettingsView()
}

