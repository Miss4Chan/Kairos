//
//  Meme.swift
//  Kairos
//
//  Created by Despina Misheva on 2.12.25.
//

import Foundation

struct Meme: Identifiable {
    let id = UUID()
    let title: String
    let imageURL: URL?
    let fallbackAssetName: String?
}

