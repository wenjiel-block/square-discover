import SwiftUI

struct MerchantReviewsSection: View {
    let reviews: [Review]
    let merchantId: String

    @Environment(Router.self) private var router

    /// Number of reviews to show in the preview.
    private let previewCount = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if reviews.isEmpty {
                EmptyStateView(
                    systemImage: "text.bubble",
                    title: "No Reviews Yet",
                    subtitle: "Be the first to review this merchant."
                )
                .frame(minHeight: 150)
            } else {
                ForEach(reviews.prefix(previewCount)) { review in
                    ReviewCardView(review: review)

                    if review.id != reviews.prefix(previewCount).last?.id {
                        Divider()
                    }
                }

                if reviews.count > previewCount {
                    seeAllButton
                }
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Reviews")
                .font(.headline)

            if !reviews.isEmpty {
                Text("(\(reviews.count))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                router.push(.writeReview(merchantId: merchantId))
            } label: {
                Label("Write Review", systemImage: "square.and.pencil")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.brandPrimary)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - See All

    private var seeAllButton: some View {
        Button {
            // In a full implementation this would navigate to a dedicated reviews list.
            // For now it is a placeholder.
        } label: {
            HStack {
                Text("See All Reviews")
                    .font(.subheadline.weight(.semibold))
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(Color.brandPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.brandPrimary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Review Card

private struct ReviewCardView: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                ratingBadge
            }

            if !review.text.isEmpty {
                Text(review.text)
                    .font(.subheadline)
                    .lineLimit(4)
                    .foregroundStyle(.primary)
            }

            if review.hasMedia {
                mediaPreview
            }

            HStack(spacing: 4) {
                Image(systemName: "hand.thumbsup")
                    .font(.caption)
                Text("\(review.likeCount)")
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
    }

    private var ratingBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundStyle(.yellow)
            Text("\(review.rating)")
                .font(.caption.weight(.bold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.surfaceSecondary, in: Capsule())
    }

    private var mediaPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(review.media.prefix(4)) { media in
                    AsyncImageView(
                        url: media.thumbnailURL ?? media.url,
                        cornerRadius: 6,
                        contentMode: .fill
                    )
                    .frame(width: 60, height: 60)
                    .clipped()
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        MerchantReviewsSection(reviews: [], merchantId: UUID().uuidString)
            .padding()
    }
    .environment(Router())
}
