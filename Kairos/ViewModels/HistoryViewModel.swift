//
//  HistoryViewModel.swift
//  Kairos
//
//  Created by Despina Misheva on 3.12.25.
//

import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {

    struct DaySection: Identifiable {
        let id: Date
        let day: Date
        let items: [TaskOccurrence]
    }

    func sections(
        completed: [TaskOccurrence],
        searchText: String,
        selectedCategoryID: UUID?
    ) -> [DaySection] {
        let filtered = filter(completed: completed, searchText: searchText, selectedCategoryID: selectedCategoryID)
        let grouped = groupByDay(occurrences: filtered)
        return grouped
    }

    func emptyMessage(searchText: String, selectedCategoryID: UUID?) -> String {
        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedCategoryID != nil {
            return "Try changing your search or filter."
        } else {
            return "Your completed tasks will appear here."
        }
    }

    // MARK: - Filtering

    private func filter(
        completed: [TaskOccurrence],
        searchText: String,
        selectedCategoryID: UUID?
    ) -> [TaskOccurrence] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return completed.filter { occ in
            //search goes on both cat and title
            let matchesSearch: Bool = {
                guard !trimmedSearch.isEmpty else { return true }
                let title = title(for: occ)
                let categoryName = occ.task?.category?.name ?? ""
                return title.localizedCaseInsensitiveContains(trimmedSearch)
                    || categoryName.localizedCaseInsensitiveContains(trimmedSearch)
            }()

            let matchesCategory: Bool = {
                guard let selectedCategoryID else { return true }
                return occ.task?.category?.id == selectedCategoryID
            }()

            return matchesSearch && matchesCategory
        }
    }

    // MARK: - Helpers
    private func groupByDay(occurrences: [TaskOccurrence]) -> [DaySection] {
        let cal = Calendar(identifier: .iso8601)
        let dict = Dictionary(grouping: occurrences) { occ in
            cal.startOfDay(for: occ.completedDate ?? .distantPast)
        }

        let days = dict.keys.sorted(by: >)
        return days.map { day in
            DaySection(id: day, day: day, items: dict[day] ?? [])
        }
    }

    func title(for occ: TaskOccurrence) -> String {
        occ.snapshotTitle ?? occ.task?.title ?? "Task"
    }

    func xp(for occ: TaskOccurrence) -> Int? {
        let difficulty = occ.snapshotDifficulty ?? occ.task?.difficulty
        guard let xp = difficulty?.xpReward, xp > 0 else { return nil }
        return xp
    }
}
