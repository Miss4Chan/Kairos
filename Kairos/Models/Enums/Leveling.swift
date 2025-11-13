//
//  Leveling.swift
//  Kairos
//
//  Created by Despina Misheva on 11.11.25.
//

import Foundation

enum Leveling {
    static let maxLevel = 99

    /// Cumulative XP required to reach level L (L in 1...99).
    /// Mirrors OSRS curve: XP(L) = floor( (1/4) * sum_{x=1}^{L-1} floor( x + 300 * 2^(x/7) ) ) - easiest and best :))
    static func xpRequired(forLevel level: Int) -> Int {
        guard level > 1 else { return 0 }
        var points = 0.0
        for x in 1..<(level) {
            points += floor(Double(x) + 300.0 * pow(2.0, Double(x)/7.0))
        }
        return Int(floor(points / 4.0))
    }

    static func level(forTotalXP xp: Int) -> Int {
        if xp <= 0 { return 1 }
        var low = 1, high = maxLevel
        while low < high {
            let mid = (low + high + 1) / 2
            if xpRequired(forLevel: mid) <= xp {
                low = mid
            } else {
                high = mid - 1
            }
        }
        return low
    }

    static func progressInLevel(totalXP xp: Int) -> (level: Int, progress: Double, currentBase: Int, nextBase: Int) {
        let lvl = level(forTotalXP: xp)
        let base = xpRequired(forLevel: lvl)
        let next = xpRequired(forLevel: min(lvl + 1, maxLevel))
        let denom = max(1, next - base)
        let p = Double(xp - base) / Double(denom)
        return (lvl, min(max(p, 0), 1), base, next)
    }
}
