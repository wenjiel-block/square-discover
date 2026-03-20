import SwiftUI

struct ReviewMediaAttachment: View {
    let media: [MediaContent]
    @State private var selectedMedia: MediaContent?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(media) { item in
                    AsyncImageView(
                        url: item.thumbnailURL ?? item.url,
                        cornerRadius: 8
                    )
                    .frame(width: 80, height: 80)
                    .clipped()
                    .onTapGesture {
                        selectedMedia = item
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedMedia) { mediaItem in
            FullScreenMediaView(media: mediaItem)
        }
    }
}

// MARK: - Full Screen Media View

private struct FullScreenMediaView: View {
    let media: MediaContent
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            AsyncImage(url: media.url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .empty:
                    ProgressView()
                        .tint(.white)
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.white.opacity(0.5))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
}

#Preview {
    ReviewMediaAttachment(media: [
        MediaContent(
            type: .image,
            url: URL(string: "https://example.com/review1.jpg")!,
            aspectRatio: 1.0
        ),
        MediaContent(
            type: .image,
            url: URL(string: "https://example.com/review2.jpg")!,
            aspectRatio: 1.0
        )
    ])
}
