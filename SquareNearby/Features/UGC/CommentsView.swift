import SwiftUI

struct CommentsView: View {
    let feedItemId: String
    @State private var viewModel = CommentsViewModel()
    @Environment(\.services) private var services
    @FocusState private var isTextFieldFocused: Bool

    private var feedItemUUID: UUID? {
        UUID(uuidString: feedItemId)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Comments List
            Group {
                if viewModel.isLoading && viewModel.comments.isEmpty {
                    LoadingView(message: "Loading comments...")
                } else if let error = viewModel.error, viewModel.comments.isEmpty {
                    ErrorView(message: error) {
                        Task {
                            if let uuid = feedItemUUID {
                                await viewModel.loadComments(
                                    feedItemId: uuid,
                                    using: services.contentService
                                )
                            }
                        }
                    }
                } else if viewModel.comments.isEmpty {
                    EmptyStateView(
                        systemImage: "bubble.left",
                        title: "No Comments Yet",
                        subtitle: "Be the first to comment."
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.comments) { comment in
                                CommentRow(comment: comment)
                                Divider()
                                    .padding(.leading, 56)
                            }
                        }
                    }
                }
            }

            Divider()

            // Comment Input
            HStack(spacing: 12) {
                TextField("Add a comment...", text: $viewModel.newCommentText, axis: .vertical)
                    .lineLimit(1...4)
                    .textFieldStyle(.plain)
                    .focused($isTextFieldFocused)

                Button {
                    Task {
                        if let uuid = feedItemUUID {
                            await viewModel.addComment(
                                feedItemId: uuid,
                                using: services.contentService
                            )
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(
                            viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? Color.secondary
                                : Color.brandPrimary
                        )
                }
                .disabled(
                    viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.vertical, 10)
            .background(Color.surfacePrimary)
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let uuid = feedItemUUID {
                await viewModel.loadComments(
                    feedItemId: uuid,
                    using: services.contentService
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommentsView(feedItemId: UUID().uuidString)
            .environment(\.services, .mock)
    }
}
