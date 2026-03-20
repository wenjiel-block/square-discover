import Foundation

@Observable
final class FeedViewModel {

    // MARK: - Published State

    private(set) var items: [FeedItem] = []
    var currentItemId: String?
    private(set) var currentIndex: Int = 0
    private(set) var isLoading: Bool = false
    private(set) var error: Error?

    // MARK: - Pagination

    private var currentPage: Int = 1
    private let pageSize: Int = 10
    private var hasMorePages: Bool = true
    private var isFetchingNextPage: Bool = false

    /// Prefetch threshold -- when the user is this many items from the end,
    /// the next page will be requested.
    private let prefetchThreshold: Int = 3

    // MARK: - Loading

    /// Loads the first page of the feed, replacing any existing items.
    func loadInitialFeed(using feedService: any FeedServiceProtocol) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        currentPage = 1
        hasMorePages = true

        do {
            let fetched = try await feedService.fetchFeed(page: currentPage, pageSize: pageSize)
            items = fetched
            hasMorePages = fetched.count >= pageSize

            if let first = items.first {
                currentItemId = first.id.uuidString
                currentIndex = 0
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }

    /// Pulls-to-refresh: reloads from page 1.
    func refresh(using feedService: any FeedServiceProtocol) async {
        await loadInitialFeed(using: feedService)
    }

    // MARK: - Visible Item Tracking / Prefetch

    /// Call this whenever the visible item changes (e.g. from `scrollPosition(id:)`).
    func onVisibleItemChanged(_ itemId: String?, using feedService: any FeedServiceProtocol) {
        guard let itemId else { return }
        currentItemId = itemId

        if let index = items.firstIndex(where: { $0.id.uuidString == itemId }) {
            currentIndex = index

            // Prefetch when approaching the end of the loaded items.
            let distanceToEnd = items.count - index - 1
            if distanceToEnd <= prefetchThreshold {
                Task {
                    await loadNextPage(using: feedService)
                }
            }
        }
    }

    // MARK: - Interaction Helpers

    /// Toggles the like state for a given feed item, updating local state optimistically.
    func toggleLike(for itemId: UUID, using feedService: any FeedServiceProtocol) async {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }

        let wasLiked = items[index].isLikedByCurrentUser

        // Optimistic update
        items[index].isLikedByCurrentUser = !wasLiked
        items[index].likeCount += wasLiked ? -1 : 1

        do {
            if wasLiked {
                try await feedService.unlikeFeedItem(itemId)
            } else {
                try await feedService.likeFeedItem(itemId)
            }
        } catch {
            // Revert on failure
            items[index].isLikedByCurrentUser = wasLiked
            items[index].likeCount += wasLiked ? 1 : -1
        }
    }

    /// Toggles the saved/bookmark state locally.
    func toggleSave(for itemId: UUID) {
        guard let index = items.firstIndex(where: { $0.id == itemId }) else { return }
        items[index].isSavedByCurrentUser.toggle()
    }

    // MARK: - Private

    private func loadNextPage(using feedService: any FeedServiceProtocol) async {
        guard !isFetchingNextPage, hasMorePages else { return }
        isFetchingNextPage = true

        let nextPage = currentPage + 1
        do {
            let fetched = try await feedService.fetchFeed(page: nextPage, pageSize: pageSize)
            // Deduplicate by id
            let existingIds = Set(items.map(\.id))
            let newItems = fetched.filter { !existingIds.contains($0.id) }
            items.append(contentsOf: newItems)
            currentPage = nextPage
            hasMorePages = fetched.count >= pageSize
        } catch {
            // Silently fail; user can scroll again to retry.
        }

        isFetchingNextPage = false
    }
}
