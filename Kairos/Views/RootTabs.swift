//
//  RootTabs.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI

///This is the view which does the top-level tab navigation
///its a container that switches between child views using tabs, inside the tab view we add the views and we make them tab items
struct RootTabs: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max.fill") }
            
            TasksView()
                .tabItem { Label("Tasks", systemImage: "checklist") }
            
            HistoryView()
                .tabItem { Label("History", systemImage: "clock") }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        /// Places a view behind another view; use when you need one view behind another
        /// I use it to put material on it since I like the liquid glass look 
        .background(.ultraThinMaterial)
    }
}

#Preview("RootTabs") {
    RootTabs()
}

