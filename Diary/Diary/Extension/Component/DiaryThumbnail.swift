//
//  DiaryThumbnail.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 15/09/26.
//


//
//  DiaryThumbnail.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 15/09/26.
//

import SwiftUI

struct DiaryThumbnail: View {
    let fileName: String?
    var size: CGFloat = 90

    var body: some View {
        ZStack {
            if let fileName, let ui = PhotoStore.load(fileName) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.black.opacity(0.85)
                Image(systemName: "book.pages.fill")
                    .font(.system(size: size * 0.44))
                    .foregroundStyle(.white.opacity(0.55))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay {
            Circle().strokeBorder(Color(red: 0.35, green: 0.55, blue: 0.98), lineWidth: 3)
        }
    }
}

#Preview {
    HStack(spacing: 0) {
        DiaryThumbnail(fileName: nil)
        DiaryThumbnail(fileName: nil, size: 60)
    }
    .padding()
    .vibrantLinearBackground()
}
