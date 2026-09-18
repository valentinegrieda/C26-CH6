//
//  DataModel.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 11/09/26.
//

import Foundation
import SwiftData


@Model
class LoginModel {
    var id = UUID()
    var username: String
    var password: String
    
    init(
        username: String = "Valentine",
        password: String = "123"
    ) {
        self.username = username
        self.password = password
    }
}

@Model
final class DiaryModel {
    var title: String
    var date: Date
    var detail: String
    var photoFileNames: [String] = []   // ["1A2B.jpeg", "3C4D.jpeg"]
    var userId: UUID = UUID()

    init(title: String, date: Date, detail: String, photoFileNames: [String] = [], userId: UUID) {
        self.title = title
        self.date = date
        self.detail = detail
        self.photoFileNames = photoFileNames
        self.userId = userId
    }
}

@Model
final class DraftModel {
    var title: String
    var date: Date
    var detail: String
    var photoFileNames: [String] = []   // ["1A2B.jpeg", "3C4D.jpeg"]
    var userId: UUID = UUID()

    init(title: String, date: Date, detail: String, photoFileNames: [String] = [], userId: UUID) {
        self.title = title
        self.date = date
        self.detail = detail
        self.photoFileNames = photoFileNames
        self.userId = userId
    }
}



extension LoginModel {
    
    static func seedDefaultUser(context: ModelContext) {
        let descriptor = FetchDescriptor<LoginModel>()
        let existing = try? context.fetch(descriptor)
        
        guard existing?.isEmpty ?? true else { return }
        
        let defaultUser = LoginModel()
        context.insert(defaultUser)
        
        do {
            try context.save()
        } catch {
            print("Failed: \(error)")
        }
    }
}
