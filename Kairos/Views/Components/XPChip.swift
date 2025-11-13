//
//  XPChip.swift
//  Kairos
//
//  Created by Despina Misheva on 11.11.25.
//

import SwiftUI

struct XPChip: View {
    var xp: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.fill")
            Text("\(xp) XP")
                .font(.headline)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity) 
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

#Preview("XPChip") {
    XPChip(xp: 275).padding()
}
