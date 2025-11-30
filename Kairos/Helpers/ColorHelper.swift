//
//  ColorHelper.swift
//  Kairos
//
//  Created by Despina Misheva on 30.11.25.
//

import SwiftUI
import UIKit

private struct ColorChoiceCircle: View {
    let title: String
    let hex: String
    @Binding var selectedHex: String
    
    var body: some View {
        Button {
            selectedHex = hex
        } label: {
            VStack {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 24, height: 24)
                    .overlay {
                        if selectedHex == hex {
                            Circle()
                                .strokeBorder(.primary, lineWidth: 2)
                        }
                    }
                
                Text(title)
                    .font(.caption2)
            }
        }
        .buttonStyle(.plain)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 8: // ARGB
            a = (int & 0xFF000000) >> 24
            r = (int & 0x00FF0000) >> 16
            g = (int & 0x0000FF00) >> 8
            b = int & 0x000000FF
        case 6: // RGB
            a = 255
            r = (int & 0xFF0000) >> 16
            g = (int & 0x00FF00) >> 8
            b = int & 0x0000FF
        default:
            a = 255
            r = 0
            g = 0
            b = 0
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let ri = Int(round(r * 255))
        let gi = Int(round(g * 255))
        let bi = Int(round(b * 255))
        
        return String(format: "#%02X%02X%02X", ri, gi, bi)
        #else
        return nil
        #endif
    }
}
