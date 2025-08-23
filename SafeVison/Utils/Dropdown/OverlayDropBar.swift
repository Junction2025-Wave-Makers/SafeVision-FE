//
//  OverlayDropBar.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import SwiftUI

struct OverlayDropBar<Content: View>: View {
    let isOpen: Bool
    let maxHeight: CGFloat
    @ViewBuilder var content: Content

    var body: some View {
        content
            .frame(height: isOpen ? maxHeight : 0)
            .clipped()
            .background(
                RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
            )
            .animation(.easeInOut(duration: 0.45), value: isOpen)
            .transition(.opacity)
    }
}
