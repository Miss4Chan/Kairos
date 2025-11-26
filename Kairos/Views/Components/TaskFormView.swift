//
//  TaskFormView.swift
//  Kairos
//
//  Created by Despina Misheva on 26.11.25.
//

import SwiftUI

struct TaskFormView: View {
    @Binding var title: String
    @Binding var recurrence: RecurrenceType
    @Binding var difficulty: Difficulty
    @Binding var hasSpecificTime: Bool
    @Binding var date: Date

    /// Allows each screen to customize the labels a bit
    var dateLabelWhenTimed: String
    var dateLabelWhenNotTimed: String

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $title)

                Picker("Difficulty", selection: $difficulty) {
                    ForEach(Difficulty.allCases) { tier in
                        Text("\(label(for: tier))")
                            .tag(tier)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Repeat", selection: $recurrence) {
                    ForEach(RecurrenceType.allCases, id: \.self) { r in
                        Text(r.displayName).tag(r)
                    }
                }

                Toggle("Specific time", isOn: $hasSpecificTime)

                DatePicker(
                    hasSpecificTime ? dateLabelWhenTimed : dateLabelWhenNotTimed,
                    selection: $date,
                    displayedComponents: hasSpecificTime ? [.date, .hourAndMinute] : [.date]
                )
            }

            Section("Preview") {
                HStack {
                    Label("\(difficulty.xpReward) XP", systemImage: "sparkles")
                    Spacer()
                    Text(recurrence.rawValue.capitalized)
                        .font(.footnote)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.thinMaterial, in: Capsule())
                }
            }
        }
    }

    private func label(for tier: Difficulty) -> String {
        switch tier {
        case .trivial: return "Trivial"
        case .easy:    return "Easy"
        case .normal:  return "Normal"
        case .hard:    return "Hard"
        case .brutal:  return "Brutal"
        }
    }
}
