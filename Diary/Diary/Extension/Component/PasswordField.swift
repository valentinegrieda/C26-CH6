//
//  PasswordField.swift
//  Diary
//

import SwiftUI

struct PasswordField: View {
    @Binding var text: String
    var placeholder: String = "Password"

    @State private var isVisible: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if isVisible {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.body)
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                } else {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.body)
                    )
                }
            }
            .textFieldStyle(.underlineStyle)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
            }
            .buttonStyle(.icon(color: .white.opacity(0.8)))
            .padding(.bottom, 14)
        }
    }
}
