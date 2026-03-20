import SwiftUI

extension View {
    /// Applies a standard card style with rounded corners, background, and shadow.
    func cardStyle() -> some View {
        self
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
            .shadow(
                color: .black.opacity(0.08),
                radius: Constants.Layout.cardShadowRadius,
                y: 2
            )
    }

    /// Applies a shimmer loading effect overlay.
    func shimmer(isActive: Bool = true) -> some View {
        modifier(ShimmerModifier(isActive: isActive))
    }
}

private struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay {
                    GeometryReader { geometry in
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.3),
                                Color.clear,
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: -geometry.size.width * 0.3 + phase * (geometry.size.width * 1.6))
                        .onAppear {
                            withAnimation(
                                .linear(duration: 1.5)
                                .repeatForever(autoreverses: false)
                            ) {
                                phase = 1
                            }
                        }
                    }
                    .clipped()
                }
                .redacted(reason: .placeholder)
        } else {
            content
        }
    }
}
