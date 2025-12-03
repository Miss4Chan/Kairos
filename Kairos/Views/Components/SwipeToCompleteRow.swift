//
//  SwipeToCompleteRow.swift
//  Kairos
//
//  Created by Despina Misheva on 11.11.25.
//

import SwiftUI

struct SwipeToCompleteRow: View {
    let task: UserTask
    let subtitle: String
    let onComplete: (UserTask) -> Void

    @State private var offsetX: CGFloat = 0
    @State private var didTriggerHaptic = false
    private let trigger: CGFloat = 96

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.green.opacity(min(0.35, max(0, Double(offsetX/220)))))

            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2.bold())
                    .opacity(offsetX > 16 ? 1 : 0.2)
                Spacer()
            }
            .padding(.leading, 16)
            .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title).font(.headline)
                if !subtitle.isEmpty {
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .materialCard(cornerRadius: 14, strokeOpacity: 0.06)
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let dx = max(0, value.translation.width)
                        offsetX = dx
                        if dx > trigger, !didTriggerHaptic {
                            didTriggerHaptic = true
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } else if dx <= trigger {
                            didTriggerHaptic = false
                        }
                    }
                    .onEnded { value in
                        if value.translation.width > trigger {
                            performComplete()
                        } else {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                                offsetX = 0
                            }
                        }
                    }
            )
        }
        .animation(.easeOut(duration: 0.12), value: offsetX)
    }

    private func performComplete() {
        onComplete(task)
        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            offsetX = 600
        }
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
}
