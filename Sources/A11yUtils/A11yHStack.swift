//
//  A11yHStack.swift
//
//
//  Created by Jacob Bartlett on 26/02/2024.
//

import SwiftUI

/// `HStack` which automatically aligns content vertically
/// when it does not fit due to text scaling.
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
            A11yFittingHStack(alignment: alignment, spacing: spacing, content: content)
            
        } else {
            A11ySimpleHStack(alignment: alignment, spacing: spacing, content: content)
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
    
    var body: some View {
        ViewThatFits {
            HStack(alignment: alignment, spacing: spacing) {
                content()
            }
            VStack(alignment: .leading, spacing: spacing) {
                content()
            }
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
