//
//  CategoryFormView.swift
//  Kairos
//
//  Created by Despina Misheva on 30.11.25.
//

import SwiftUI

struct CategoryFormView: View {
    @Binding var name: String
    @Binding var iconName: String
    @Binding var selectedColor: Color
    
    let suggestedSymbols: [String]
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Category name", text: $name)
            }
            
            Section("Icon") {
                let columns = [GridItem(.adaptive(minimum: 40))]
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(suggestedSymbols, id: \.self) { symbol in
                        Button {
                            iconName = symbol
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        iconName == symbol ? Color.accentColor : Color.secondary.opacity(0.3),
                                        lineWidth: iconName == symbol ? 2 : 1
                                    )
                                    .frame(width: 40, height: 40)
                                Image(systemName: symbol)
                                    .font(.system(size: 18))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                
                TextField("Custom SF Symbol name (optional)", text: $iconName)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                if !iconName.isEmpty {
                    HStack(spacing: 8) {
                        Text("Preview:")
                        Image(systemName: iconName)
                    }
                    .font(.caption)
                }
                
                Text("Tap an icon above or enter any valid SF Symbol name.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Color") {
                ColorPicker("Category color", selection: $selectedColor, supportsOpacity: false)
            }
        }
    }
}

#Preview {
    @Previewable @State var name = "Work"
    @Previewable @State var icon = "briefcase.fill"
    @Previewable @State var color = Color(hex: "#3D85C6")
    
    let symbols = ["house.fill", "briefcase.fill", "book.closed.fill"]
    
    return NavigationStack {
        CategoryFormView(
            name: $name,
            iconName: $icon,
            selectedColor: $color,
            suggestedSymbols: symbols
        )
        .navigationTitle("New Category")
    }
}
