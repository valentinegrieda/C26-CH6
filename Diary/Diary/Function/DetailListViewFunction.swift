//
//  DetailListViewFunction.swift
//  Diary
//

import SwiftUI
import SwiftData

extension DetailListView {
    func deletelist() {
        PhotoStore.delete(entry.photoFileNames)
        modelContext.delete(entry)
        dismiss()
    }
}
