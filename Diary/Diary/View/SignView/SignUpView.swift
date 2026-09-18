//
//  SignUpView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 16/09/26.
//


//
//  SignUpView.swift
//  Diary
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var showAlert = false
    @State var alertMessage = ""

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            VStack(spacing: 35) {
                TextField("", text: $username,
                          prompt: Text("Username")
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.body))
                    .textFieldStyle(.underlineStyle)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                PasswordField(text: $password, placeholder: "Password")

                PasswordField(text: $confirmPassword, placeholder: "Confirm Password")
                
                VStack(spacing: 20) {
                    Button("SIGN UP") {
                        signUp()
                    }
                    .buttonStyle(.tealOval)
                    
                    HStack(spacing: 0) {
                        Text("ALREADY HAVE AN ACCOUNT? ")
                            .foregroundStyle(.white)
                            .font(.caption)

                        NavigationLink {
                            SignInView()
                        } label: {
                            Text("SIGN IN")
                                .foregroundStyle(.teal)
                                .font(.caption)
                                .underline()
                        }
                    }
                    
                }

                
            }
            .frame(width: 288)
            .padding()
        }
        .vibrantLinearBackground()
        .navigationBarBackButtonHidden(true)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Sign Up Failed", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

}

#Preview {
    NavigationStack {
        SignUpView()
    }
    .modelContainer(for: LoginModel.self, inMemory: true)
}
