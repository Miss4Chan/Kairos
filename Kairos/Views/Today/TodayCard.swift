//
//  TodayCard.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import SwiftUI

struct TodayCard: View {
    var date: Date = Date()
    var body: some View {
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        let wdf = DateFormats.weekdayWide
        let monthDF = DateFormats.monthAbbrev
        
        return HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                HStack{
                    Image(systemName: "calendar")
                        .imageScale(.small)
                    Text(wdf.string(from: date))
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .allowsTightening(true)
                }
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(day)")
                        .font(.system(size: 28, weight: .bold))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .allowsTightening(true)
                    
                    Text(monthDF.string(from: date).uppercased())
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .allowsTightening(true)
                }
            }
        }
        .padding(12)
    }
}

#Preview("TodayCard") {
    TodayCard()
        .padding()
}
