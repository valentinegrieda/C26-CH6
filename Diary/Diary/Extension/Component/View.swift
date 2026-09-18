//
//  View+Extensions.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI

struct VibrantLinearBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    stops: [

                        .init(color: .bgGreen, location: 0.05),
                        .init(color: .bgBlue, location: 0.65)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea(.container)
    }
}


extension View {
    func vibrantLinearBackground() -> some View {
        self.modifier(VibrantLinearBackground())
    }
}
