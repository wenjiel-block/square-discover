import Foundation

final class MockMerchantService: MerchantServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchNearbyMerchants(
        latitude: Double,
        longitude: Double,
        radiusMiles: Double,
        cuisines: [Cuisine]?,
        sortBy: MerchantSortOption
    ) async throws -> [Merchant] {
        try await Task.sleep(for: .milliseconds(450))
        var results = store.merchants

        // Apply cuisine filter
        if let cuisines, !cuisines.isEmpty {
            results = results.filter { merchant in
                merchant.cuisineTypes.contains { cuisines.contains($0) }
            }
        }

        // Apply radius filter based on distanceMiles
        results = results.filter { merchant in
            (merchant.location.distanceMiles ?? 0) <= radiusMiles
        }

        // Sort
        switch sortBy {
        case .distance:
            results.sort { ($0.location.distanceMiles ?? .greatestFiniteMagnitude) < ($1.location.distanceMiles ?? .greatestFiniteMagnitude) }
        case .rating:
            results.sort { $0.rating > $1.rating }
        case .popular:
            results.sort { $0.reviewCount > $1.reviewCount }
        case .newest:
            // Mock: reverse order to simulate newest
            results.reverse()
        }

        return results
    }

    func fetchMerchant(id: UUID) async throws -> Merchant {
        try await Task.sleep(for: .milliseconds(300))
        guard let merchant = store.merchants.first(where: { $0.id == id }) else {
            throw ServiceError.notFound
        }
        return merchant
    }

    func searchMerchants(query: String) async throws -> [Merchant] {
        try await Task.sleep(for: .milliseconds(400))
        let lowered = query.lowercased()
        return store.merchants.filter { merchant in
            merchant.name.lowercased().contains(lowered) ||
            merchant.description.lowercased().contains(lowered) ||
            merchant.cuisineTypes.contains { $0.displayName.lowercased().contains(lowered) } ||
            merchant.address.lowercased().contains(lowered) ||
            merchant.tags.contains { $0.lowercased().contains(lowered) }
        }
    }
}
