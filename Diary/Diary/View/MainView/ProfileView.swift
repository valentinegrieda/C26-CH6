//
//  ProfileView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 11/09/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @State private var navigateToSign: Bool = false
    @State private var isPasswordVisible: Bool = false

    @Environment(\.modelContext) private var modelContext
    @Query var LoginModel: [LoginModel]
    @AppStorage("loggedInUserId") private var loggedInUserId: String = ""

    private var currentUser: LoginModel? {
        LoginModel.first { $0.id.uuidString == loggedInUserId }
    }

    private var maskedPassword: String {
        String(repeating: "•", count: currentUser?.password.count ?? 0)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Username: \(currentUser?.username ?? "")")

                        HStack(spacing: 8) {
                            Text("Password: \(isPasswordVisible ? (currentUser?.password ?? "") : maskedPassword)")

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            }
                            .buttonStyle(.icon)
                        }

                    }
                    .font(.headline)
                    .foregroundColor(.white)


                    Button("SIGN OUT") {
                        loggedInUserId = ""
                        navigateToSign = true
                    }
                    .buttonStyle(.blueOval)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Text("Profile")
                    .font(.title)
                        .foregroundStyle(.black)
                        .padding(.top,42)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
            .vibrantLinearBackground()
            .navigationDestination(isPresented: $navigateToSign) {
                SignInView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
