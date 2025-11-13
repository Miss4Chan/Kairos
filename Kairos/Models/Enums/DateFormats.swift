//
//  DateFormats.swift
//  Kairos
//
//  Created by Despina Misheva on 12.11.25.
//

import Foundation

enum DateFormats {
    static let dateOnlyMedium: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()

    static let dateTimeMediumShort: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    static let weekdayWide: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        return df
    }()

    static let monthAbbrev: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM"
        return df
    }()

    static let dayMedium: DateFormatter = dateOnlyMedium
    static let timeShort: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        return df
    }()
}
