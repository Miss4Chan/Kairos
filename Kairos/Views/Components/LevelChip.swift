//
//  LevelChip.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI

struct LevelChip: View {
    var level: Int
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "shield.fill")
            Text("Lv \(level)")
                .font(.headline)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

#Preview("LevelChip") {
    LevelChip(level: 4).padding()
}
