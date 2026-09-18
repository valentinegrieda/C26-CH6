//
//  SignInViewFunction.swift
//  Diary
//

import SwiftUI
import SwiftData

extension SignInView {
    func signIn() {
        if username == "" || password == "" {
            showIncompleteAlert = true
            return
        }

        guard let login = LoginModel.first(where: { $0.username == username }) else {
            showWrongLoginAlert = true
            return
        }

        if password != login.password {
            showWrongLoginAlert = true
            return
        }

        loggedInUserId = login.id.uuidString
        navigateToHome = true
    }
}
