import SwiftUI

enum SkeletonShape {
    case rectangle
    case circle
    case roundedRectangle(cornerRadius: CGFloat = 8)
}

struct SkeletonView: View {
    var shape: SkeletonShape = .roundedRectangle()

    @State private var isAnimating = false

    var body: some View {
        skeletonShape
            .fill(Color.secondary.opacity(0.15))
            .overlay {
                skeletonShape
                    .fill(shimmerGradient)
                    .mask(skeletonShape.fill(Color.white))
            }
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }

    private var shimmerGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.clear,
                Color.white.opacity(0.3),
                Color.clear,
            ],
            startPoint: isAnimating ? .trailing : .leading,
            endPoint: isAnimating
                ? UnitPoint(x: 2, y: 0.5)
                : UnitPoint(x: 1, y: 0.5)
        )
    }

    @ViewBuilder
    private var skeletonShape: some InsettableShape {
        switch shape {
        case .rectangle:
            Rectangle()
        case .circle:
            // Use a RoundedRectangle with a very large corner radius to emulate a circle
            // as InsettableShape, since Circle does not conform to InsettableShape the same way.
            RoundedRectangle(cornerRadius: 9999)
        case .roundedRectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        SkeletonView(shape: .roundedRectangle(cornerRadius: 12))
            .frame(height: 200)

        HStack(spacing: 12) {
            SkeletonView(shape: .circle)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 8) {
                SkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 150, height: 14)
                SkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 100, height: 12)
            }
        }

        SkeletonView(shape: .rectangle)
            .frame(height: 40)
    }
    .padding()
}
