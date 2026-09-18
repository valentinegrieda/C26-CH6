//
//  SignUpViewFunction.swift
//  Diary
//

import SwiftUI
import SwiftData

extension SignUpView {
    func signUp() {
        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill all fields"
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }

        modelContext.insert(LoginModel(username: username, password: password))
        dismiss()
    }
}
