//
//  MemeService.swift
//  Kairos
//
//  Created by Despina Misheva on 2.12.25.
//

import Foundation

enum MemeService {
    static func fetchWholesomeMeme() async -> Meme {
        if let online = await fetchOnlineWholesome(retries: 2) {
            return online
        }

        let fallbacks = ["Meme1", "Meme2", "Meme3"]
        let pick = fallbacks.randomElement() ?? "Meme1"
        return Meme(title: "Offline wholesome meme", imageURL: nil, fallbackAssetName: pick)
    }

    //need to have retries in case smth goes wrong or the meme is not appropirate
    private static func fetchOnlineWholesome(retries: Int) async -> Meme? {
        let endpoint = URL(string: "https://meme-api.com/gimme/wholesomememes")!

        do {
            let (data, _) = try await URLSession.shared.data(from: endpoint)
            let decoded = try JSONDecoder().decode(APIResponse.self, from: data)

            // hahahhahahahahah gotta do this make it safe for the children
            if decoded.nsfw == true || decoded.spoiler == true {
                guard retries > 0 else { return nil }
                return await fetchOnlineWholesome(retries: retries - 1)
            }

            return Meme(
                title: decoded.title,
                imageURL: URL(string: decoded.url),
                fallbackAssetName: nil
            )
        } catch {
            return nil
        }
    }

    private struct APIResponse: Decodable {
        let title: String
        let url: String
        let nsfw: Bool?
        let spoiler: Bool?
        let preview: [String]?
    }
}
