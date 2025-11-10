//
//  ShimmerLoadingView.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 08/11/2025.
//

import SwiftUI

public struct ShimmerLoadingView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<5) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1), .gray.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: 90)
                    .shimmerAnimation()
            }
        }
        .padding()
    }
}

private extension View {
    func shimmerAnimation() -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .rotationEffect(.degrees(30))
            .offset(x: -250)
            .mask(self)
            .animation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false),
                value: UUID()
            )
        )
    }
}
