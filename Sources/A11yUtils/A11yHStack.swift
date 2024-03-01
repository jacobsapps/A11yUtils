//
//  A11yHStack.swift
//
//
//  Created by Jacob Bartlett on 26/02/2024.
//

import SwiftUI

/// `HStack` which converts into a `VStack` if content will not fit horizontally at larger text scales.
///
/// Below iOS 16, `ViewThatFits` is not available, so this simply converts an `HStack` into a
/// `.leading`-aligned `VStack` when sizeCategory is an accessibility category (AX1 through AX5).
///
public struct A11yHStack<Content: View>: View {
    
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    public init(alignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        if #available(iOS 16.0, *) {
            A11yFittingHStack(alignment: alignment,
                              spacing: spacing,
                              content: content)
            
        } else {
            A11ySimpleHStack(alignment: alignment,
                             spacing: spacing,
                             content: content)
        }
    }
}

@available(iOS 16.0, *)
private struct A11yFittingHStack<Content: View>: View {
    
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    init(alignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    /// I think an even better approach would be applying some kind of flow Layout in the instance where content
    /// does not fit, so it's more robust to looking good with multiple horizontal items. I was unable to make it work
    /// with the flow layout from objc.io, but I welcome contributions.
    ///
    var body: some View {
        ViewThatFits {
            HStack(alignment: alignment, spacing: spacing) {
                content()
            }
            VStack(alignment: .leading, spacing: spacing) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct A11ySimpleHStack<Content: View>: View {
    
    @Environment(\.sizeCategory) private var sizeCategory
    
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    init(alignment: VerticalAlignment = .center,
         spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        if sizeCategory.isAccessibilityCategory {
            VStack(alignment: .leading, spacing: spacing) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack(alignment: alignment, spacing: spacing) {
                content()
            }
        }
    }
}
