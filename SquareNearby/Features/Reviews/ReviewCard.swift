import SwiftUI

struct ReviewCard: View {
    let review: Review
    @State private var isLiked = false
    @State private var isExpanded = false

    private let maxCollapsedLength = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author Row
            HStack(spacing: 10) {
                AvatarView(
                    url: review.author.avatarURL,
                    initials: review.author.displayName,
                    size: 36
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.author.displayName)
                        .font(.subheadline.weight(.semibold))

                    Text(review.timeAgo)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()
            }

            // Star Rating
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= review.rating ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundStyle(index <= review.rating ? .yellow : .gray.opacity(0.3))
                }
            }

            // Review Text (expandable)
            if !review.text.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(displayText)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(isExpanded ? nil : 4)

                    if review.text.count > maxCollapsedLength {
                        Button {
                            withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                                isExpanded.toggle()
                            }
                        } label: {
                            Text(isExpanded ? "Show less" : "Read more")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Color.brandPrimary)
                        }
                    }
                }
            }

            // Media Thumbnails
            if review.hasMedia {
                ReviewMediaAttachment(media: review.media)
            }

            // Like Button
            HStack {
                Button {
                    isLiked.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(isLiked ? .red : .secondary)

                        Text("\(review.likeCount + (isLiked ? 1 : 0))")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
        .padding(Constants.Layout.horizontalPadding)
        .cardStyle()
    }

    private var displayText: String {
        if isExpanded || review.text.count <= maxCollapsedLength {
            return review.text
        }
        return String(review.text.prefix(maxCollapsedLength)) + "..."
    }
}

#Preview {
    ReviewCard(
        review: Review(
            author: UserProfile(
                displayName: "John Smith",
                username: "johnsmith"
            ),
            merchantId: UUID(),
            rating: 4,
            text: "Amazing food and great atmosphere! The tacos were perfectly seasoned and the guacamole was fresh. Definitely coming back. Highly recommend the al pastor tacos.",
            likeCount: 12,
            createdAt: Date.now.addingTimeInterval(-7200)
        )
    )
    .padding()
}
