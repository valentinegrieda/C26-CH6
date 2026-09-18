//
//  Button.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 10/09/26.
//

import SwiftUI


struct OvalButtonStyle: ButtonStyle {
    var backgroundColor: Color
    //var width: CGFloat? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .bold()
            .foregroundColor(.white)
            //.padding(.horizontal, 60)
            .padding(.vertical, 15)
            .frame(width: 220)
            .background(Capsule().fill(backgroundColor))
            .overlay(
                Capsule()
                    .stroke(backgroundColor, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            
    }
}


extension ButtonStyle where Self == OvalButtonStyle {

    static func oval(color: Color) -> OvalButtonStyle {
        OvalButtonStyle(backgroundColor: color)
    }

    static var tealOval: OvalButtonStyle { .oval(color: .teal) }
    static var blueOval: OvalButtonStyle { .oval(color: .blue) }
    static var orangeOval: OvalButtonStyle { .oval(color: .orange) }

}


struct IconButtonStyle: ButtonStyle {
    var color: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(color)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

extension ButtonStyle where Self == IconButtonStyle {
    static var icon: IconButtonStyle { IconButtonStyle() }

    static func icon(color: Color) -> IconButtonStyle {
        IconButtonStyle(color: color)
    }
}
