//
//  XPProgressBar.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI

struct XPProgressBar: View {
    var progress: Double // 0...1

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.15))
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: max(0, min(1, progress)) * geo.size.width)
                    .animation(.easeInOut(duration: 0.35), value: progress)
                    .foregroundStyle(
                        LinearGradient(colors: [.blue, .mint], startPoint: .leading, endPoint: .trailing)
                    )
            }
        }
    }
}

#Preview("XPProgressBar") {
    XPProgressBar(progress: 0.6)
        .frame(width: 180, height: 50)
        .padding()
}
