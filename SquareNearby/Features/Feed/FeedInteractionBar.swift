import SwiftUI

/// Vertical bar of interaction buttons displayed on the right side of a feed card.
struct FeedInteractionBar: View {
    let item: FeedItem
    @Bindable var viewModel: FeedViewModel
    @Environment(\.services) private var services

    @State private var isLikeAnimating: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            // Like
            interactionButton(
                systemImage: item.isLikedByCurrentUser ? "heart.fill" : "heart",
                count: item.formattedLikeCount,
                tint: item.isLikedByCurrentUser ? .red : .white,
                action: likeTapped
            )

            // Comment
            interactionButton(
                systemImage: "bubble.right",
                count: item.formattedCommentCount,
                tint: .white,
                action: commentTapped
            )

            // Share
            interactionButton(
                systemImage: "arrowshape.turn.up.right",
                count: item.formattedShareCount,
                tint: .white,
                action: shareTapped
            )

            // Bookmark / Save
            interactionButton(
                systemImage: item.isSavedByCurrentUser ? "bookmark.fill" : "bookmark",
                count: nil,
                tint: item.isSavedByCurrentUser ? .brandPrimary : .white,
                action: saveTapped
            )
        }
    }

    // MARK: - Interaction Button

    private func interactionButton(
        systemImage: String,
        count: String?,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(tint)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                    .scaleEffect(isLikeAnimating && systemImage.hasPrefix("heart") ? 1.3 : 1.0)

                if let count {
                    Text(count)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions

    private func likeTapped() {
        HapticManager.impact(.light)

        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            isLikeAnimating = true
        }

        // Reset the scale animation after a brief delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isLikeAnimating = false
            }
        }

        Task {
            await viewModel.toggleLike(for: item.id, using: services.feedService)
        }
    }

    private func commentTapped() {
        HapticManager.selection()
        // Comment sheet presentation would be handled by the parent or a coordinator.
    }

    private func shareTapped() {
        HapticManager.selection()
        // Share sheet presentation would be handled by the parent or a coordinator.
    }

    private func saveTapped() {
        HapticManager.impact(.light)
        viewModel.toggleSave(for: item.id)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
    }
}
