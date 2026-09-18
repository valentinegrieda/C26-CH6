//
//  DiaryApp.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI
import SwiftData

@main
struct DiaryApp: App {
    
    let container: ModelContainer

    init() {
            do {
                container = try ModelContainer(for: LoginModel.self, DiaryModel.self, DraftModel.self)
            } catch {
                fatalError("\(error)")
            }

            LoginModel.seedDefaultUser(context: container.mainContext)
        }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
