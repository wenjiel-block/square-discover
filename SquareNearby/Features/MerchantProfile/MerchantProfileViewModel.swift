import Foundation
import SwiftUI

@Observable
final class MerchantProfileViewModel {

    // MARK: - Published State

    var merchant: Merchant?
    var feedItems: [FeedItem] = []
    var reviews: [Review] = []
    var isLoading: Bool = false
    var isFavorited: Bool = false
    var error: Error?

    // MARK: - Private

    private let merchantId: UUID

    // MARK: - Init

    init(merchantId: String) {
        self.merchantId = UUID(uuidString: merchantId) ?? UUID()
    }

    // MARK: - Computed

    var hasError: Bool {
        error != nil
    }

    var errorMessage: String {
        error?.localizedDescription ?? "An unexpected error occurred."
    }

    // MARK: - Load

    func load(using services: ServiceContainer) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            async let merchantFetch = services.merchantService.fetchMerchant(id: merchantId)
            async let feedFetch = services.feedService.fetchFeedForMerchant(merchantId, page: 1)
            async let reviewsFetch = services.reviewService.fetchReviews(merchantId: merchantId, page: 1)
            async let favoriteFetch = services.favoritesService.isMerchantFavorited(merchantId)

            let (fetchedMerchant, fetchedFeed, fetchedReviews, fetchedFavorite) = try await (
                merchantFetch,
                feedFetch,
                reviewsFetch,
                favoriteFetch
            )

            merchant = fetchedMerchant
            feedItems = fetchedFeed
            reviews = fetchedReviews
            isFavorited = fetchedFavorite
        } catch {
            self.error = error
        }

        isLoading = false
    }

    // MARK: - Favorite

    func toggleFavorite(using services: ServiceContainer) async {
        let previousState = isFavorited
        isFavorited.toggle()

        do {
            if isFavorited {
                try await services.favoritesService.addFavoriteMerchant(merchantId)
            } else {
                try await services.favoritesService.removeFavoriteMerchant(merchantId)
            }
        } catch {
            // Revert on failure.
            isFavorited = previousState
            self.error = error
        }
    }
}
