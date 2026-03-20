import SwiftUI

/// A full-screen image card used for feed items whose content type is `.image`.
/// Shows the image scaled to fill the entire card area, with a thumbnail fallback.
struct FeedImageCardView: View {
    let content: MediaContent

    var body: some View {
        AsyncImage(url: content.url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .empty:
                placeholder
            case .failure:
                failurePlaceholder
            @unknown default:
                placeholder
            }
        }
        // Ensure the image stretches edge-to-edge and clips any overflow.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }

    // MARK: - Placeholders

    private var placeholder: some View {
        ZStack {
            Color.black

            if let thumbnailURL = content.thumbnailURL {
                AsyncImage(url: thumbnailURL) { thumbnailPhase in
                    switch thumbnailPhase {
                    case .success(let thumb):
                        thumb
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 10)
                    default:
                        ProgressView()
                            .tint(.white)
                    }
                }
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
    }

    private var failurePlaceholder: some View {
        ZStack {
            Color.black

            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.5))

                Text("Unable to load image")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
}

#Preview {
    FeedImageCardView(
        content: MediaContent(
            type: .image,
            url: URL(string: "https://example.com/photo.jpg")!
        )
    )
    .frame(height: 600)
}
