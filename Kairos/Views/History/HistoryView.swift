//
//  HistoryView.swift
//  Kairos
//
//  Created by Despina Misheva on 11.11.25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var ctx
    
    @Query(
        filter: #Predicate<TaskOccurrence> { $0.completedDate != nil },
        sort: [SortDescriptor(\TaskOccurrence.completedDate, order: .reverse)]
    )
    private var completed: [TaskOccurrence]
    
    @Query(sort: \Category.name) private var categories: [Category]
    
    @StateObject private var vm = HistoryViewModel()
    
    @State private var searchText: String = ""
    @State private var selectedCategoryID: UUID? = nil
    
    @FocusState private var searchFocused: Bool
    @State private var showHistoryInfo = false
    
    private var sections: [HistoryViewModel.DaySection] {
        vm.sections(
            completed: completed,
            searchText: searchText,
            selectedCategoryID: selectedCategoryID
        )
    }
    
    var body: some View {
        NavigationStack {
            List {
                if sections.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                        
                        Text(searchText.isEmpty && selectedCategoryID == nil ? "No history yet" : "No matches")
                            .font(.title3.weight(.semibold))
                        
                        Text(vm.emptyMessage(searchText: searchText, selectedCategoryID: selectedCategoryID))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 48)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(sections) { section in
                        Section(DateFormats.dayMedium.string(from: section.day)) {
                            ForEach(section.items, id: \.id) { occ in
                                HistoryRowView(
                                    occ: occ,
                                    title: vm.title(for: occ),
                                    xp: vm.xp(for: occ)
                                )
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        try? SchedulingService.undo(occ, ctx: ctx)
                                    } label: {
                                        Label("Undo", systemImage: "arrow.uturn.backward")
                                    }
                                    .tint(.orange)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("History")
            .toolbar { toolbarContent }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .searchFocused($searchFocused)
        }
        .alert("Tip", isPresented: $showHistoryInfo) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can undo completed tasks by swiping them in the History list.")
        }
        
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showHistoryInfo = true
            } label: {
                Image(systemName: "info.circle")
            }
        }
        
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu {
                Button {
                    selectedCategoryID = nil
                } label: {
                    Label("All categories", systemImage: selectedCategoryID == nil ? "checkmark" : "")
                }
                
                if !categories.isEmpty {
                    Divider()
                    ForEach(categories) { cat in
                        Button {
                            selectedCategoryID = cat.id
                        } label: {
                            Label(cat.name, systemImage: (selectedCategoryID == cat.id) ? "checkmark" : "")
                        }
                    }
                }
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            
            if selectedCategoryID != nil || !searchText.isEmpty {
                Button("Clear") {
                    searchText = ""
                    selectedCategoryID = nil
                }
            }
        }
    }
}

#Preview("HistoryView") {
    PreviewHarness(root: HistoryView())
}
