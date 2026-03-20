import Foundation

@Observable
final class CommentsViewModel {
    var comments: [Comment] = []
    var newCommentText: String = ""
    var isLoading: Bool = false
    var error: String?

    @MainActor
    func loadComments(feedItemId: UUID, using contentService: any ContentServiceProtocol) async {
        isLoading = true
        error = nil

        do {
            comments = try await contentService.fetchComments(feedItemId: feedItemId, page: 1)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    @MainActor
    func addComment(feedItemId: UUID, using contentService: any ContentServiceProtocol) async {
        let text = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        do {
            let comment = try await contentService.addComment(feedItemId: feedItemId, text: text)
            comments.append(comment)
            newCommentText = ""
        } catch {
            self.error = error.localizedDescription
        }
    }
}
