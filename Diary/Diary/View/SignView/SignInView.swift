//
//  SignView.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI
import SwiftData


struct SignInView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var navigateToHome = false
    @State var showIncompleteAlert = false
    @State var showWrongLoginAlert = false

    @Environment(\.modelContext) private var modelContext
    @Query var LoginModel: [LoginModel]
    @AppStorage("loggedInUserId") var loggedInUserId: String = ""

    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing:35) {
                    
                    TextField(
                        "",
                        text: $username,
                        prompt: Text("Username")
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.body)
                    )
                    .textFieldStyle(.underlineStyle)
                    
                    
                    PasswordField(text: $password, placeholder: "Password")
                    
                    VStack(spacing:20) {
                        Button("SIGN IN") {
                            //navigateToHome = true
                            signIn()
                        }
                        .buttonStyle(.tealOval)
                        
                        HStack(spacing: 0) {
                            Text("DIDN'T HAVE ACCOUNT YET? ")
                                .foregroundStyle(.white)
                                .font(.caption)

                            NavigationLink {
                                SignUpView()
                            } label: {
                                Text("SIGN UP")
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
            .navigationDestination(isPresented: $navigateToHome) {
                MainTabView()
            }
            .navigationBarBackButtonHidden(true)
        }
        
        
        .alert("Incomplete Field", isPresented: $showIncompleteAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please fill all fields before press SIGN IN")
        }
        
        .alert("Wrong Login", isPresented: $showWrongLoginAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Username or password is incorrect")
        }
        
    }
    
}




#Preview {
    SignInView()
}
