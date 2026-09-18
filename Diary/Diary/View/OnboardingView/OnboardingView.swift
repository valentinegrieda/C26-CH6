//
//  OnboardingView.swift
//  Diary
//

import SwiftUI

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State var selection = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Write Your Story",
            description: "Capture your day, thoughts, and moments in your own personal diary.",
            systemImage: "book.fill"
        ),
        OnboardingPage(
            title: "Save as Draft",
            description: "Not ready to finish? Save your entry as a draft and continue anytime.",
            systemImage: "square.and.pencil"
        ),
        OnboardingPage(
            title: "Add Photos",
            description: "Bring your memories to life by attaching photos to your diary entries.",
            systemImage: "photo.on.rectangle.angled"
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(selection == pages.count - 1 ? "GET STARTED" : "NEXT") {
                onboardingButtonTapped()
            }
            .buttonStyle(.tealOval)
            .padding(.bottom, 40)
        }
        .vibrantLinearBackground()
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundStyle(.white)

            Text(page.title)
                .font(.title.bold())
                .foregroundStyle(.white)

            Text(page.description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
