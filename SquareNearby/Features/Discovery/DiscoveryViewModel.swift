import Foundation
import SwiftUI

@Observable
final class DiscoveryViewModel {

    // MARK: - Published State

    var merchants: [Merchant] = []
    var searchText: String = ""
    var selectedCuisines: Set<Cuisine> = []
    var sortOption: MerchantSortOption = .distance
    var isMapMode: Bool = false
    var isLoading: Bool = false
    var error: Error?

    // MARK: - Private

    /// Default center: San Francisco (37.7749, -122.4194).
    private let defaultLatitude: Double = 37.7749
    private let defaultLongitude: Double = -122.4194
    private var searchRadiusMiles: Double = Constants.Map.defaultSearchRadiusMiles

    // MARK: - Computed

    var filteredMerchants: [Merchant] {
        var result = merchants

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter { merchant in
                merchant.name.lowercased().contains(query) ||
                merchant.cuisineTypes.contains { $0.displayName.lowercased().contains(query) } ||
                merchant.tags.contains { $0.lowercased().contains(query) }
            }
        }

        if !selectedCuisines.isEmpty {
            result = result.filter { merchant in
                !merchant.cuisineTypes.filter { selectedCuisines.contains($0) }.isEmpty
            }
        }

        return result
    }

    var hasError: Bool {
        error != nil
    }

    var errorMessage: String {
        error?.localizedDescription ?? "An unexpected error occurred."
    }

    // MARK: - Actions

    func loadMerchants(using services: ServiceContainer) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            let location = services.locationService.currentLocation
            let lat = location?.latitude ?? defaultLatitude
            let lon = location?.longitude ?? defaultLongitude

            let cuisineFilter: [Cuisine]? = selectedCuisines.isEmpty ? nil : Array(selectedCuisines)

            merchants = try await services.merchantService.fetchNearbyMerchants(
                latitude: lat,
                longitude: lon,
                radiusMiles: searchRadiusMiles,
                cuisines: cuisineFilter,
                sortBy: sortOption
            )
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func search(using services: ServiceContainer) async {
        guard !searchText.isEmpty else {
            await loadMerchants(using: services)
            return
        }

        isLoading = true
        error = nil

        do {
            merchants = try await services.merchantService.searchMerchants(query: searchText)
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func applyFilters(using services: ServiceContainer) async {
        await loadMerchants(using: services)
    }

    func toggleCuisine(_ cuisine: Cuisine) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
    }

    func clearFilters() {
        selectedCuisines.removeAll()
        sortOption = .distance
        searchRadiusMiles = Constants.Map.defaultSearchRadiusMiles
    }

    func updateSearchRadius(_ radius: Double) {
        searchRadiusMiles = min(radius, Constants.Map.maxSearchRadiusMiles)
    }
}
