import Foundation

@Observable
final class CartViewModel {

    // MARK: - Dependencies

    private let cartManager: CartManager

    init(cartManager: CartManager) {
        self.cartManager = cartManager
    }

    // MARK: - Computed Properties (delegated to CartManager/Cart)

    var items: [CartItem] {
        cartManager.cart.items
    }

    var isEmpty: Bool {
        cartManager.cart.isEmpty
    }

    var itemCount: Int {
        cartManager.cart.itemCount
    }

    var subtotalCents: Int {
        cartManager.cart.subtotalCents
    }

    var taxCents: Int {
        cartManager.cart.taxCents
    }

    var totalCents: Int {
        cartManager.cart.totalCents
    }

    var formattedSubtotal: String {
        cartManager.cart.formattedSubtotal
    }

    var formattedTax: String {
        cartManager.cart.formattedTax
    }

    var formattedTotal: String {
        cartManager.cart.formattedTotal
    }

    var merchantId: UUID? {
        cartManager.cart.merchantId
    }

    /// The merchant name is derived from the first item's merchant name if available.
    /// In a production app this would be stored on the Cart itself.
    var merchantName: String {
        guard let first = items.first else { return "" }
        return first.menuItem.name.isEmpty ? "Merchant" : ""
    }

    // MARK: - Actions

    func updateQuantity(for item: CartItem, quantity: Int) {
        cartManager.updateQuantity(for: item, quantity: quantity)
    }

    func removeItem(_ item: CartItem) {
        cartManager.removeItem(item)
    }

    func clearCart() {
        cartManager.clearCart()
    }
}
