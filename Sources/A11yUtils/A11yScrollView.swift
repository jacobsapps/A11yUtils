//
//  A11yScrollView.swift
//
//
//  Created by Jacob Bartlett on 26/02/2024.
//

import SwiftUI

public extension View {

    /// Enable content to scroll, but only when content does not fit in the `View`. Otherwise, it remains static.
    ///
    /// Below iOS 16.4, `scrollBounceBehavior` does not exist, so this always converts views into a `ScrollView`.
    ///
    @ViewBuilder
    func a11yScrollView() -> some View {
        modifier(A11yScrollViewModifier())
    }
}

struct A11yScrollViewModifier: ViewModifier {

    /// I want to implement a `ViewThatFits` approach below iOS 16.4 and a `GeometryReader`
    /// approach below iOS 16. Unfortunately, the `ViewThatFits` approach causes weird behaviour
    /// when a keyboard appears/disappears - this resizes the view and can cause infinite loops. The
    /// naïve solution to this would be multiple APIs, or a parameter, but this leaks to the other implementations...
    /// 
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            ScrollView {
                content
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            
        } else {
            ScrollView {
                content
            }
        }
    }
}
