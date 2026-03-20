import Foundation

struct MenuCategory: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let sortOrder: Int
    var items: [MenuItem]

    init(
        id: UUID = UUID(),
        name: String,
        sortOrder: Int = 0,
        items: [MenuItem] = []
    ) {
        self.id = id
        self.name = name
        self.sortOrder = sortOrder
        self.items = items
    }

    var itemCount: Int {
        items.count
    }

    var availableItems: [MenuItem] {
        items.filter(\.isAvailable)
    }

    var hasAvailableItems: Bool {
        items.contains(where: \.isAvailable)
    }
}
