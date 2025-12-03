//
//  MemeRewardView.swift
//  Kairos
//
//  Created by Despina Misheva on 2.12.25.
//


import SwiftUI

struct MemeRewardView: View {
    let meme: Meme

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Nice work!")
                    .font(.title2.weight(.semibold))
                    .padding(.top, 8)

                Text(meme.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                memeContent
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 360)
                    .padding(.horizontal, 12)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder
    private var memeContent: some View {
        if let url = meme.imageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView().padding(.vertical, 24)
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    fallbackImage
                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        Group {
            if let asset = meme.fallbackAssetName {
                Image(asset).resizable().scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding(48)
            }
        }
    }
}

#Preview("MemeRewardView (offline)") {
    MemeRewardView(
        meme: Meme(title: "Offline wholesome", imageURL: nil, fallbackAssetName: "Meme1")
    )
}

#Preview("MemeRewardView (online url)") {
    MemeRewardView(
        meme: Meme(
            title: "You did it!",
            imageURL: URL(string: "https://picsum.photos/800/600"),
            fallbackAssetName: nil
        )
    )
}
