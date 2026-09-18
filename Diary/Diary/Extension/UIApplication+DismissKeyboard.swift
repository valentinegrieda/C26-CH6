//
//  UIApplication+DismissKeyboard.swift
//  Diary
//

import UIKit

/// Allows the window-level keyboard-dismiss tap to recognize simultaneously with other
/// gesture recognizers (e.g. a SwiftUI Button's), so it no longer wins the first tap and
/// forces buttons app-wide to need a second tap to register.
private final class KeyboardDismissGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    static let shared = KeyboardDismissGestureDelegate()

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

extension UIApplication {
    /// Installs a window-level tap gesture that dismisses the keyboard when tapping outside it,
    /// without blocking taps/gestures belonging to other views (e.g. DatePicker).
    func installKeyboardDismissOnTap() {
        guard let window = connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        guard window.gestureRecognizers?.contains(where: { $0.name == "dismissKeyboardOnTap" }) != true else { return }

        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.name = "dismissKeyboardOnTap"
        tapGesture.cancelsTouchesInView = false
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.delegate = KeyboardDismissGestureDelegate.shared
        window.addGestureRecognizer(tapGesture)
    }
}
