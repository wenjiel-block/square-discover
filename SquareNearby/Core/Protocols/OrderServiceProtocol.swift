import Foundation

/// Defines the interface for placing, tracking, and managing orders.
protocol OrderServiceProtocol: AnyObject, Sendable {

    /// Places a new order at a merchant.
    /// - Parameters:
    ///   - merchantId: The unique identifier of the merchant to order from.
    ///   - items: An array of order line-item identifiers and quantities.
    ///   - pickupTime: The requested pickup time, or `nil` for ASAP.
    /// - Returns: The newly created order.
    func placeOrder(
        merchantId: UUID,
        items: [OrderLineItem],
        pickupTime: Date?
    ) async throws -> Order

    /// Fetches the current state of a single order.
    /// - Parameter id: The unique identifier of the order.
    /// - Returns: The order matching the given identifier.
    func fetchOrder(id: UUID) async throws -> Order

    /// Fetches the current user's order history, paginated.
    /// - Parameter page: The page number (1-indexed).
    /// - Returns: An array of past orders.
    func fetchOrderHistory(page: Int) async throws -> [Order]

    /// Fetches all orders that are currently active (not yet picked up or cancelled).
    /// - Returns: An array of active orders.
    func fetchActiveOrders() async throws -> [Order]

    /// Cancels an existing order. Only orders that have not yet begun preparation may be cancelled.
    /// - Parameter id: The unique identifier of the order to cancel.
    func cancelOrder(id: UUID) async throws
}

/// Represents a single line item when placing an order.
struct OrderLineItem: Codable, Hashable, Sendable {
    let menuItemId: UUID
    let quantity: Int
    let specialInstructions: String?

    init(menuItemId: UUID, quantity: Int, specialInstructions: String? = nil) {
        self.menuItemId = menuItemId
        self.quantity = quantity
        self.specialInstructions = specialInstructions
    }
}
