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
        let currentBadge = BadgeCatalog.currentBadge(forLevel: info.level)
        let nextBadge = BadgeCatalog.nextBadge(forLevel: info.level)
        
        
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
                    if let badge = currentBadge {
                        Image(systemName: badge.iconName)
                            .imageScale(.large)
                        Text(badge.name)
                            .font(.headline)
                        Text(badge.description)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        
                        if let next = nextBadge {
                            Text("Next: \(next.name) at level \(next.unlockLevel)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        } else {
                            Text("You’ve unlocked the highest badge!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }
                    } else {
                        Image(systemName: "rosette")
                            .imageScale(.large)
                        Text("No badge yet")
                            .font(.headline)
                        Text("Complete tasks to earn XP and unlock your first badge.")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
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
