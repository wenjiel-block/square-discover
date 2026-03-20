import Foundation

final class MockOrderService: OrderServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func placeOrder(
        merchantId: UUID,
        items: [OrderLineItem],
        pickupTime: Date?
    ) async throws -> Order {
        try await Task.sleep(for: .milliseconds(500))

        guard let merchant = store.merchants.first(where: { $0.id == merchantId }) else {
            throw ServiceError.notFound
        }

        // Resolve menu items from line items
        var orderItems: [OrderItem] = []
        for lineItem in items {
            guard let menuItem = MockMenuItems.menuItem(for: lineItem.menuItemId) else {
                throw ServiceError.invalidInput("Menu item not found: \(lineItem.menuItemId)")
            }
            orderItems.append(OrderItem(
                menuItem: menuItem,
                quantity: lineItem.quantity,
                specialInstructions: lineItem.specialInstructions
            ))
        }

        let subtotal = orderItems.reduce(0) { $0 + $1.totalPriceCents }
        let tax = Int(round(Double(subtotal) * 0.0875))

        let order = Order(
            merchantId: merchantId,
            merchantName: merchant.name,
            items: orderItems,
            status: .placed,
            subtotalCents: subtotal,
            taxCents: tax,
            totalCents: subtotal + tax,
            pickupTime: pickupTime,
            createdAt: .now,
            estimatedReadyAt: Calendar.current.date(
                byAdding: .minute,
                value: merchant.estimatedPickupTime ?? 20,
                to: .now
            )
        )

        store.orders.insert(order, at: 0)
        return order
    }

    func fetchOrder(id: UUID) async throws -> Order {
        try await Task.sleep(for: .milliseconds(300))
        guard let order = store.orders.first(where: { $0.id == id }) else {
            throw ServiceError.notFound
        }
        return order
    }

    func fetchOrderHistory(page: Int) async throws -> [Order] {
        try await Task.sleep(for: .milliseconds(400))
        let pageSize = 10
        let sorted = store.orders.sorted { $0.createdAt > $1.createdAt }
        let start = (page - 1) * pageSize
        guard start < sorted.count else { return [] }
        let end = min(start + pageSize, sorted.count)
        return Array(sorted[start..<end])
    }

    func fetchActiveOrders() async throws -> [Order] {
        try await Task.sleep(for: .milliseconds(350))
        return store.orders.filter(\.isActive).sorted { $0.createdAt > $1.createdAt }
    }

    func cancelOrder(id: UUID) async throws {
        try await Task.sleep(for: .milliseconds(400))
        guard let index = store.orders.firstIndex(where: { $0.id == id }) else {
            throw ServiceError.notFound
        }

        let order = store.orders[index]
        guard order.status == .placed || order.status == .confirmed else {
            throw ServiceError.invalidInput("Cannot cancel an order that is already being prepared.")
        }

        store.orders[index].status = .cancelled
    }
}
