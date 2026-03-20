import Foundation

final class MockMenuService: MenuServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchMenu(merchantId: UUID) async throws -> [MenuCategory] {
        try await Task.sleep(for: .milliseconds(400))
        guard let categories = store.menuCategories[merchantId.uuidString] else {
            // Return an empty menu for merchants without detailed menus
            return []
        }
        return categories.sorted { $0.sortOrder < $1.sortOrder }
    }

    func fetchMenuItem(id: UUID) async throws -> MenuItem {
        try await Task.sleep(for: .milliseconds(300))
        for categories in store.menuCategories.values {
            for category in categories {
                if let item = category.items.first(where: { $0.id == id }) {
                    return item
                }
            }
        }
        throw ServiceError.notFound
    }
}
