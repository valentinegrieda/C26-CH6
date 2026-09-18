//
//  DiaryRow.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 15/09/26.
//

import SwiftUI

struct DiaryRowListView: View {
    let entry: DiaryModel

    var body: some View {
        HStack(spacing: 18) {
            //thumbnail
            DiaryThumbnail(fileName: entry.photoFileNames.first)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, format: .dateTime.day().month(.abbreviated).year())
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))

                Text(entry.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)
        }
    }
}

struct DiaryRowDraftView: View {
    let entry: DraftModel

    var body: some View {
        HStack(spacing: 18) {
            //thumbnail
            DiaryThumbnail(fileName: entry.photoFileNames.first)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, format: .dateTime.day().month(.abbreviated).year())
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))

                Text(entry.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)
        }
    }
}

struct DiaryRowHomeListView: View {
    let entry: DiaryModel
    
    var body: some View {
        HStack(spacing: 18) {
            DiaryThumbnail(fileName: entry.photoFileNames.first)
        }
    }
}

struct DiaryRowHomeDraftView: View {
    let entry: DraftModel
    
    var body: some View {
        HStack(spacing: 18) {
            DiaryThumbnail(fileName: entry.photoFileNames.first)
        }
    }
}
