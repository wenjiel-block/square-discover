import Foundation

@Observable
final class MenuViewModel {

    // MARK: - Published State

    private(set) var categories: [MenuCategory] = []
    var selectedCategory: MenuCategory?
    private(set) var isLoading: Bool = false
    private(set) var error: Error?

    // MARK: - Loading

    /// Loads the full menu for a given merchant, organized by category.
    func loadMenu(merchantId: String, using menuService: any MenuServiceProtocol) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            guard let uuid = UUID(uuidString: merchantId) else {
                throw ServiceError.invalidInput("Invalid merchant ID")
            }
            let fetched = try await menuService.fetchMenu(merchantId: uuid)
            categories = fetched.sorted { $0.sortOrder < $1.sortOrder }

            if selectedCategory == nil, let first = categories.first {
                selectedCategory = first
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }

    // MARK: - Category Selection

    func selectCategory(_ category: MenuCategory) {
        selectedCategory = category
    }

    // MARK: - Computed

    /// All available menu items across all categories.
    var allItems: [MenuItem] {
        categories.flatMap(\.availableItems)
    }

    /// Items for the currently selected category, or all items if none selected.
    var visibleItems: [MenuItem] {
        guard let selectedCategory else { return allItems }
        return selectedCategory.availableItems
    }
}
