//
//  BadgesLevelsView.swift
//  Kairos
//
//  Created by Despina Misheva on 12.11.25.
//

import SwiftUI
import SwiftData

struct BadgesLevelsView: View {
    @Query private var profiles: [UserProfile]
    private var profile: UserProfile? { profiles.first }

    private var levelInfo: (level: Int, progress: Double, totalXP: Int, base: Int, next: Int) {
        let xp = profile?.totalXP ?? 0
        let p = Leveling.progressInLevel(totalXP: xp)
        return (p.level, p.progress, xp, p.currentBase, p.nextBase)
    }

    var body: some View {
        let info = levelInfo

        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "shield")
                        .imageScale(.large)
                    Text("Level \(info.level)")
                        .font(.title2.weight(.semibold))
                }
                .padding(.top, 8)

                XPProgressBar(progress: info.progress)
                    .frame(height: 50)
                    .padding(8)
                    .materialCard().padding(.horizontal, 24)

                VStack(spacing: 8) {
                    Image(systemName: "rosette")
                        .imageScale(.large)
                    Text("Current Badge")
                        .font(.headline)
                    Text("Badges coming soon")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .materialCard()
                .padding(.horizontal, 16)

                Text("\(info.totalXP) XP total")
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Badges and Levels")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Badges & Levels") {
    PreviewHarness(root: BadgesLevelsView())
}
