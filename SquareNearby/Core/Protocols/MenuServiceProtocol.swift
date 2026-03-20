import Foundation

/// Defines the interface for fetching merchant menus and individual menu items.
protocol MenuServiceProtocol: AnyObject, Sendable {

    /// Fetches the full menu for a merchant, organized by category.
    /// - Parameter merchantId: The unique identifier of the merchant.
    /// - Returns: An array of menu categories, each containing its menu items.
    func fetchMenu(merchantId: UUID) async throws -> [MenuCategory]

    /// Fetches the details of a single menu item.
    /// - Parameter id: The unique identifier of the menu item.
    /// - Returns: The menu item matching the given identifier.
    func fetchMenuItem(id: UUID) async throws -> MenuItem
}
