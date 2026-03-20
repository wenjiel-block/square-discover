import SwiftUI

struct CommentRow: View {
    let comment: Comment
    @State private var isLiked = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AvatarView(
                url: comment.author.avatarURL,
                initials: comment.author.displayName,
                size: 32
            )

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(comment.author.username)
                        .font(.subheadline.weight(.semibold))

                    Text(comment.timeAgo)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Text(comment.text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }

            Spacer()

            // Like button
            Button {
                isLiked.toggle()
            } label: {
                VStack(spacing: 2) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.caption)
                        .foregroundStyle(isLiked ? .red : .secondary)

                    if comment.likeCount > 0 || isLiked {
                        Text("\(comment.likeCount + (isLiked ? 1 : 0))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.vertical, 10)
    }
}

#Preview {
    CommentRow(
        comment: Comment(
            author: UserProfile(
                displayName: "Jane Doe",
                username: "janedoe"
            ),
            text: "This looks delicious! I need to try this place.",
            likeCount: 5,
            createdAt: Date.now.addingTimeInterval(-3600)
        )
    )
}
