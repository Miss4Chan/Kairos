//
//  CategoryRowView.swift
//  Kairos
//
//  Created by Despina Misheva on 30.11.25.
//

import SwiftUI

struct CategoryRowView: View {
    let category: Category
    let showsChevron: Bool
    let usedCount: Int
    
    var body: some View {
        HStack(spacing: 12) {
            if let iconName = category.iconName, !iconName.isEmpty {
                Image(systemName: iconName)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: category.colorHex))
                        .frame(width: 10, height: 10)
                    
                    if let iconName = category.iconName, !iconName.isEmpty {
                        Text(iconName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                if usedCount > 0 {
                    Text("Used by \(usedCount) task\(usedCount == 1 ? "" : "s")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    let sample = Category(name: "Work", colorHex: "#3D85C6", iconName: "briefcase.fill")
    return List {
        CategoryRowView(category: sample, showsChevron: true,  usedCount: 5)
    }
}
