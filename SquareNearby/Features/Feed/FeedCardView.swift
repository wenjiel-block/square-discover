import SwiftUI

struct FeedCardView: View {
    let item: FeedItem
    @Bindable var viewModel: FeedViewModel
    @Environment(VideoPlayerManager.self) private var videoManager

    var body: some View {
        ZStack {
            // Layer 1: Media content
            mediaLayer

            // Layer 2: Gradient overlay on the bottom 40%
            gradientOverlay

            // Layer 3: Interactive overlay content
            overlayContent
        }
        .clipped()
    }

    // MARK: - Layer 1: Media

    @ViewBuilder
    private var mediaLayer: some View {
        if item.content.isVideo {
            VideoPlayerView(
                player: videoManager.player(for: item.id.uuidString)
            )
            .ignoresSafeArea()
        } else {
            FeedImageCardView(content: item.content)
                .ignoresSafeArea()
        }
    }

    // MARK: - Layer 2: Gradient

    private var gradientOverlay: some View {
        VStack {
            Spacer()

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.3),
                    .black.opacity(0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: UIScreen.main.bounds.height * 0.4)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Layer 3: Overlay Content

    private var overlayContent: some View {
        VStack {
            Spacer()

            HStack(alignment: .bottom, spacing: 12) {
                FeedOverlayView(item: item)

                Spacer()

                FeedInteractionBar(item: item, viewModel: viewModel)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 34) // Account for home indicator
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
    }
}
