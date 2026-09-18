//
//  DiaryStore.swift
//  Diary
//

import Foundation
import SwiftData

enum DiaryStore {
    static func saveDiary(
        context: ModelContext,
        title: String,
        date: Date,
        detail: String,
        photoFileNames: [String],
        userId: UUID
    ) {
        let entry = DiaryModel(title: title, date: date, detail: detail, photoFileNames: photoFileNames, userId: userId)
        context.insert(entry)
    }

    static func saveDraft(
        context: ModelContext,
        title: String,
        date: Date,
        detail: String,
        photoFileNames: [String],
        userId: UUID
    ) {
        let entry = DraftModel(title: title, date: date, detail: detail, photoFileNames: photoFileNames, userId: userId)
        context.insert(entry)
    }
}
