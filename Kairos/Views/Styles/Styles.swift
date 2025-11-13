//
//  Styles.swift
//  Kairos
//
//  Created by Despina Misheva on 12.11.25.
//

import SwiftUI

struct CapsuleTag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.thinMaterial, in: Capsule())
    }
}

struct MaterialCard: ViewModifier {
    var cornerRadius: CGFloat = 16
    var strokeOpacity: Double? = nil
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                if let strokeOpacity {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Color.primary.opacity(strokeOpacity))
                }
            }
    }
}

extension View {
    func materialCard(cornerRadius: CGFloat = 16, strokeOpacity: Double? = nil) -> some View {
        modifier(MaterialCard(cornerRadius: cornerRadius, strokeOpacity: strokeOpacity))
    }
    func capsuleTag() -> some View { modifier(CapsuleTag()) }
}
