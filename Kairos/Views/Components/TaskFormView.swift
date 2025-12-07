//
//  TaskFormView.swift
//  Kairos
//
//  Created by Despina Misheva on 26.11.25.
//

import SwiftUI
import SwiftData

struct TaskFormView: View {
    @Query(sort: \Category.name) private var categories: [Category]
    
    /// Binding means that its a reference to some other state that is owned by someone else (kinda like input and output in angular) 
    @Binding var title: String
    @Binding var recurrence: RecurrenceType
    @Binding var difficulty: Difficulty
    @Binding var hasSpecificTime: Bool
    @Binding var date: Date
    @Binding var selectedCategory: Category?
    
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
            
            Section("Category") {
                if categories.isEmpty {
                    Text("No categories yet. You can add some from Settings → Categories.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Picker("Category", selection: Binding(
                        get: { selectedCategory },
                        set: { selectedCategory = $0 }
                    )) {
                        Text("None")
                            .tag(Category?.none)
                        
                        ForEach(categories) { category in
                            HStack {
                                if let iconName = category.iconName {
                                    Image(systemName: iconName)
                                }
                                Text(category.name)
                            }
                            .tag(Category?.some(category))
                        }
                    }
                }
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
