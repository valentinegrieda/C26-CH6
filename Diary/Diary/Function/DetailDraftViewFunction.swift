//
//  DetailDraftViewFunction.swift
//  Diary
//

import SwiftUI
import SwiftData
import PhotosUI

extension DetailDraftView {
    @MainActor
    func loadPhotos(_ items: [PhotosPickerItem]) async {
        isLoadingPhotos = true
        defer {
            isLoadingPhotos = false
            pickerItems = []
        }

        for item in items {
            guard let raw = try? await item.loadTransferable(type: Data.self),
                  let name = PhotoStore.saveCompressed(raw) else { continue }
            entry.photoFileNames.append(name)
            addedPhotoFileNames.insert(name)
        }
    }

    func deletePhoto(_ name: String) {
        entry.photoFileNames.removeAll { $0 == name }

        if addedPhotoFileNames.remove(name) != nil {
            // Added and removed again within this session, nothing was ever saved.
            PhotoStore.delete([name])
        } else {
            // Was part of the saved draft; only actually delete it once the change is confirmed.
            pendingRemovedPhotoFileNames.insert(name)
        }
    }

    func confirmBack() {
        if hasUnsavedChanges {
            showBackConfirm = true
        } else {
            dismiss()
        }
    }

    func saveChangesAndDismiss() {
        PhotoStore.delete(Array(pendingRemovedPhotoFileNames))
        pendingRemovedPhotoFileNames.removeAll()
        addedPhotoFileNames.removeAll()

        try? modelContext.save()
        dismiss()
    }

    func discardChangesAndDismiss() {
        PhotoStore.delete(Array(addedPhotoFileNames))
        addedPhotoFileNames.removeAll()
        pendingRemovedPhotoFileNames.removeAll()

        entry.title = originalTitle
        entry.date = originalDate
        entry.detail = originalDetail
        entry.photoFileNames = originalPhotoFileNames

        try? modelContext.save()
        dismiss()
    }

    func publish() {
        let diary = DiaryModel(title: entry.title,
                               date: entry.date,
                               detail: entry.detail,
                               photoFileNames: entry.photoFileNames,
                               userId: entry.userId)
        modelContext.insert(diary)
        modelContext.delete(entry)
        dismiss()
    }

    func deletedraft() {
        PhotoStore.delete(entry.photoFileNames)
        modelContext.delete(entry)
        dismiss()
    }
}
