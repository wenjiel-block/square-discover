import SwiftUI

struct FeedView: View {
    @Environment(\.services) private var services
    @State private var viewModel = FeedViewModel()
    @State private var videoManager = VideoPlayerManager()
    @State private var scrolledItemId: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if viewModel.isLoading && viewModel.items.isEmpty {
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
            } else if let error = viewModel.error, viewModel.items.isEmpty {
                ErrorView(
                    message: "Failed to load feed",
                    description: error.localizedDescription
                ) {
                    Task {
                        await viewModel.refresh(using: services.feedService)
                    }
                }
                .foregroundStyle(.white)
            } else {
                feedScrollView
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .task {
            await viewModel.loadInitialFeed(using: services.feedService)
        }
        .onChange(of: scrolledItemId) { _, newValue in
            viewModel.onVisibleItemChanged(newValue, using: services.feedService)
            videoManager.updateVisibility(
                currentId: newValue,
                items: viewModel.items,
                currentIndex: viewModel.currentIndex
            )
        }
        .environment(videoManager)
    }

    // MARK: - Feed Scroll

    private var feedScrollView: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.items) { item in
                        FeedCardView(item: item, viewModel: viewModel)
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                            .id(item.id.uuidString)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrolledItemId)
        }
    }
}

#Preview {
    FeedView()
        .environment(\.services, .mock)
}
