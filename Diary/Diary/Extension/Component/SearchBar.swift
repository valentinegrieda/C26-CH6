//
//  SearchBar.swift
//  Diary
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 16) {
            TextField(
                "",
                text: $text,
                prompt: Text("Search")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.body)
            )
            .textFieldStyle(.underlineStyle)

            Button {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil)
            } label: {
                ZStack {
                    Circle().fill(.blue)
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .semibold))
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}
