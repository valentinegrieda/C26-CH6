//
//  RootView.swift
//  Diary
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        Group {
            if hasSeenOnboarding {
                SignInView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            UIApplication.shared.installKeyboardDismissOnTap()
        }
    }
}

#Preview {
    RootView()
}
