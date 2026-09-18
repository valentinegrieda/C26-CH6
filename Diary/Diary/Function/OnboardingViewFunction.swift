//
//  OnboardingViewFunction.swift
//  Diary
//

import SwiftUI

extension OnboardingView {
    func onboardingButtonTapped() {
        if selection == pages.count - 1 {
            hasSeenOnboarding = true
        } else {
            withAnimation {
                selection += 1
            }
        }
    }
}
