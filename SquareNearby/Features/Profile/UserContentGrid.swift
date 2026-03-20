import SwiftUI

struct UserContentGrid: View {
    let feedItems: [FeedItem]
    @Environment(Router.self) private var router

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        if feedItems.isEmpty {
            EmptyStateView(
                systemImage: "camera",
                title: "No Posts Yet",
                subtitle: "Share your favorite food moments."
            )
            .frame(height: 200)
        } else {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(feedItems) { item in
                    GridThumbnail(feedItem: item)
                        .onTapGesture {
                            router.push(.comments(feedItemId: item.id.uuidString))
                        }
                }
            }
        }
    }
}

// MARK: - Grid Thumbnail

private struct GridThumbnail: View {
    let feedItem: FeedItem

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                AsyncImageView(
                    url: feedItem.content.thumbnailURL ?? feedItem.content.url,
                    cornerRadius: 0
                )
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.width
                )
                .clipped()

                // Video indicator
                if feedItem.content.isVideo {
                    Image(systemName: "play.fill")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(.black.opacity(0.5), in: Circle())
                        .padding(6)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    UserContentGrid(feedItems: [])
        .environment(Router())
}
