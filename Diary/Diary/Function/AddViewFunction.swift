//
//  AddView+Actions.swift
//  Diary
//

import Foundation

extension AddView {
    var currentUserId: UUID {
        UUID(uuidString: loggedInUserId) ?? UUID()
    }

    func savediary() {
        let names = imageData.compactMap { PhotoStore.save($0.data) }
        DiaryStore.saveDiary(context: modelContext, title: title, date: date, detail: detail, photoFileNames: names, userId: currentUserId)

        resetForm()
        selectedTab = 1
    }

    func savedraft() {
        let names = imageData.compactMap { PhotoStore.save($0.data) }
        DiaryStore.saveDraft(context: modelContext, title: title, date: date, detail: detail, photoFileNames: names, userId: currentUserId)

        resetForm()
        selectedTab = 3
    }

    func resetForm() {
        title = ""
        detail = ""
        date = Date()
        imageData = []
        pickerItems = []
    }
}
