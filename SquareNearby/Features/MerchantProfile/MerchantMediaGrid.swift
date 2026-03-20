import SwiftUI

struct MerchantMediaGrid: View {
    let feedItems: [FeedItem]

    @Environment(Router.self) private var router

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
    ]

    var body: some View {
        if feedItems.isEmpty {
            EmptyStateView(
                systemImage: "photo.on.rectangle.angled",
                title: "No Photos Yet",
                subtitle: "Photos from this merchant will appear here."
            )
            .frame(minHeight: 200)
        } else {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(feedItems) { item in
                    thumbnailView(for: item)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
        }
    }

    // MARK: - Thumbnail

    private func thumbnailView(for item: FeedItem) -> some View {
        Button {
            router.push(.comments(feedItemId: item.id.uuidString))
        } label: {
            ZStack(alignment: .topTrailing) {
                AsyncImageView(
                    url: item.content.thumbnailURL ?? item.content.url,
                    cornerRadius: 0,
                    contentMode: .fill
                )
                .frame(minHeight: 120)
                .aspectRatio(1, contentMode: .fill)
                .clipped()

                if item.content.isVideo {
                    videoBadge
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var videoBadge: some View {
        Image(systemName: "play.fill")
            .font(.caption2)
            .foregroundStyle(.white)
            .padding(4)
            .background(.black.opacity(0.6), in: Circle())
            .padding(6)
    }
}

#Preview {
    MerchantMediaGrid(feedItems: [])
        .padding()
        .environment(Router())
}
