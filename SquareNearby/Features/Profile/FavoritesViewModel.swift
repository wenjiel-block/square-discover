import Foundation

@Observable
final class FavoritesViewModel {
    var merchants: [Merchant] = []
    var menuItems: [MenuItem] = []
    var isLoading: Bool = false
    var error: String?

    @MainActor
    func load(using favoritesService: any FavoritesServiceProtocol) async {
        isLoading = true
        error = nil

        do {
            async let fetchedMerchants = favoritesService.fetchFavoriteMerchants()
            async let fetchedMenuItems = favoritesService.fetchFavoriteMenuItems()

            merchants = try await fetchedMerchants
            menuItems = try await fetchedMenuItems
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
