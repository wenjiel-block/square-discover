import Foundation

/// Defines the interface for managing the current user's favorite merchants and menu items.
protocol FavoritesServiceProtocol: AnyObject, Sendable {

    /// Fetches all merchants the current user has favorited.
    /// - Returns: An array of favorited merchants.
    func fetchFavoriteMerchants() async throws -> [Merchant]

    /// Fetches all menu items the current user has favorited.
    /// - Returns: An array of favorited menu items.
    func fetchFavoriteMenuItems() async throws -> [MenuItem]

    /// Adds a merchant to the current user's favorites.
    /// - Parameter merchantId: The unique identifier of the merchant to favorite.
    func addFavoriteMerchant(_ merchantId: UUID) async throws

    /// Removes a merchant from the current user's favorites.
    /// - Parameter merchantId: The unique identifier of the merchant to unfavorite.
    func removeFavoriteMerchant(_ merchantId: UUID) async throws

    /// Adds a menu item to the current user's favorites.
    /// - Parameter menuItemId: The unique identifier of the menu item to favorite.
    func addFavoriteMenuItem(_ menuItemId: UUID) async throws

    /// Removes a menu item from the current user's favorites.
    /// - Parameter menuItemId: The unique identifier of the menu item to unfavorite.
    func removeFavoriteMenuItem(_ menuItemId: UUID) async throws

    /// Checks whether a merchant is in the current user's favorites.
    /// - Parameter merchantId: The unique identifier of the merchant.
    /// - Returns: `true` if the merchant is favorited, `false` otherwise.
    func isMerchantFavorited(_ merchantId: UUID) async throws -> Bool
}
