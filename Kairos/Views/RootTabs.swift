//
//  RootTabs.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI

struct RootTabs: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max.fill") }

            TasksView()
                .tabItem { Label("Tasks", systemImage: "checklist") }
            
            HistoryView()
                .tabItem { Label("History", systemImage: "clock") }
        }.background(.ultraThinMaterial)
    }
}

#Preview("RootTabs") {
    RootTabs()
}

