//
//  TodayHeader.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI
struct TodayHeader: View {
    var progress: Double
    var level: Int
    var xp: Int
    
    private let columnSpacing: CGFloat = 12
    private let horizontalPadding: CGFloat = 16
    
    var body: some View {
        GeometryReader { geo in
            let total = geo.size.width - (horizontalPadding * 2) - columnSpacing
            let leftWidth = floor(total * 2/3)
            let rightWidth = total - leftWidth
            
            HStack(alignment: .top, spacing: columnSpacing) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 8) {
                        NavigationLink {
                            BadgesLevelsView()
                        } label: {
                            LevelChip(level: level)
                        }
                        /// frame is the size/constraints of a view 
                        .frame(maxWidth: .infinity, alignment: .leading)
                        XPChip(xp: xp)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 44)
                    
                    XPProgressBar(progress: progress)
                        .frame(height: 50)
                        .padding(8)
                        .materialCard()
                }
                .frame(width: leftWidth, alignment: .leading)
                
                TodayCard()
                    .frame(width: rightWidth)
                    .frame(maxHeight: .infinity)
                    .materialCard()
            }
            .padding(.horizontal, horizontalPadding)
            .frame(maxHeight: 120, alignment: .top)
        }
        .frame(height: 130)
        .clipped()
    }
}

#Preview("TodayHeader") {
    PreviewHarness(root: TodayHeader(progress: 0.42, level: 3, xp: 257))
}

