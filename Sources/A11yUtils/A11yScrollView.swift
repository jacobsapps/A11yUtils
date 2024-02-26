//
//  A11yScrollView.swift
//
//
//  Created by Jacob Bartlett on 26/02/2024.
//

import SwiftUI

public extension View {

    /// Intelligently handle scrolling behaviour of SwiftUI Views for larger content sizes.
    ///
    /// `viewContainsTextFields` needs to be set, because the `ViewThatFits` implementation
    /// can cause infinite resizing loops when the keyboard is invoked.
    ///
    @ViewBuilder
    func a11yScrollView() -> some View {
        modifier(A11yScrollViewModifier())
    }
}

struct A11yScrollViewModifier: ViewModifier {
        
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
