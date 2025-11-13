//
//  EmptyStateView.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI

struct EmptyStateView: View {
    var title: String
    var message: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(title).font(.headline)
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

#Preview("EmptyStateView") {
    EmptyStateView(title: "Nothing here", message: "Add something to get started.")
        .padding()
}
