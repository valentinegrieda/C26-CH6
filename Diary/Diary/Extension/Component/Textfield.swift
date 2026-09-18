//
//  Textfield.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI

struct UnderlineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .foregroundColor(.white)
            .padding(.bottom, 14)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white),
                alignment: .bottom
            )
    }
}

extension TextFieldStyle where Self == UnderlineTextFieldStyle {
    static var underlineStyle: UnderlineTextFieldStyle { UnderlineTextFieldStyle() }
}
