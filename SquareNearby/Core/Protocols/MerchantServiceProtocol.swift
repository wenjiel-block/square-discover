import Foundation

/// Sort options for merchant search and discovery results.
enum MerchantSortOption: String, Codable, Hashable, CaseIterable, Sendable {
    case distance
    case rating
    case popular
    case newest

    var displayName: String {
        switch self {
        case .distance: return "Distance"
        case .rating: return "Rating"
        case .popular: return "Popular"
        case .newest: return "Newest"
        }
    }
}

/// Defines the interface for discovering and fetching merchant information.
protocol MerchantServiceProtocol: AnyObject, Sendable {

    /// Fetches merchants near a given coordinate, optionally filtered and sorted.
    /// - Parameters:
    ///   - latitude: The latitude of the search center.
    ///   - longitude: The longitude of the search center.
    ///   - radiusMiles: The search radius in miles.
    ///   - cuisines: An optional set of cuisine filters to apply.
    ///   - sortBy: The sort order for the results.
    /// - Returns: An array of merchants matching the criteria.
    func fetchNearbyMerchants(
        latitude: Double,
        longitude: Double,
        radiusMiles: Double,
        cuisines: [Cuisine]?,
        sortBy: MerchantSortOption
    ) async throws -> [Merchant]

    /// Fetches the full details for a single merchant.
    /// - Parameter id: The unique identifier of the merchant.
    /// - Returns: The merchant matching the given identifier.
    func fetchMerchant(id: UUID) async throws -> Merchant

    /// Searches for merchants by a text query (name, cuisine, location, etc.).
    /// - Parameter query: The search text.
    /// - Returns: An array of merchants matching the query.
    func searchMerchants(query: String) async throws -> [Merchant]
}
