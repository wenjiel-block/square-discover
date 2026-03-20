import Foundation

final class MockFavoritesService: FavoritesServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchFavoriteMerchants() async throws -> [Merchant] {
        try await Task.sleep(for: .milliseconds(400))
        return store.merchants.filter { store.favoriteMerchantIds.contains($0.id.uuidString) }
    }

    func fetchFavoriteMenuItems() async throws -> [MenuItem] {
        try await Task.sleep(for: .milliseconds(400))
        return MockMenuItems.allItems.filter { store.favoriteMenuItemIds.contains($0.id.uuidString) }
    }

    func addFavoriteMerchant(_ merchantId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        store.favoriteMerchantIds.insert(merchantId.uuidString)
    }

    func removeFavoriteMerchant(_ merchantId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        store.favoriteMerchantIds.remove(merchantId.uuidString)
    }

    func addFavoriteMenuItem(_ menuItemId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        store.favoriteMenuItemIds.insert(menuItemId.uuidString)
    }

    func removeFavoriteMenuItem(_ menuItemId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        store.favoriteMenuItemIds.remove(menuItemId.uuidString)
    }

    func isMerchantFavorited(_ merchantId: UUID) async throws -> Bool {
        try await Task.sleep(for: .milliseconds(300))
        return store.favoriteMerchantIds.contains(merchantId.uuidString)
    }
}
