import Foundation
import SwiftUI

/// Represents a pending merchant switch when the user tries to add an item from a different merchant.
struct PendingMerchantSwitch: Sendable {
    let newMerchantId: UUID
    let newMerchantName: String
    let item: MenuItem
    let quantity: Int
    let customizations: [CustomizationOption]
}

@Observable
final class CartManager: @unchecked Sendable {
    private(set) var cart: Cart
    var pendingMerchantSwitch: PendingMerchantSwitch?

    init(cart: Cart = Cart()) {
        self.cart = cart
    }

    // MARK: - Cart Operations

    func addItem(
        _ item: MenuItem,
        quantity: Int = 1,
        customizations: [CustomizationOption] = [],
        merchantName: String = ""
    ) {
        // Check if adding from a different merchant
        if let currentMerchantId = cart.merchantId, currentMerchantId != item.merchantId {
            pendingMerchantSwitch = PendingMerchantSwitch(
                newMerchantId: item.merchantId,
                newMerchantName: merchantName,
                item: item,
                quantity: quantity,
                customizations: customizations
            )
            return
        }

        cart.addItem(item, quantity: quantity, customizations: customizations)
    }

    func removeItem(_ cartItem: CartItem) {
        cart.removeItem(cartItem)
    }

    func updateQuantity(for cartItem: CartItem, quantity: Int) {
        cart.updateQuantity(for: cartItem, quantity: quantity)
    }

    func clearCart() {
        cart.clear()
    }

    // MARK: - Merchant Switch Handling

    func confirmMerchantSwitch() {
        guard let pending = pendingMerchantSwitch else { return }

        // Clear existing cart and add the new item
        cart.clear()
        cart.addItem(
            pending.item,
            quantity: pending.quantity,
            customizations: pending.customizations
        )

        pendingMerchantSwitch = nil
    }

    func cancelMerchantSwitch() {
        pendingMerchantSwitch = nil
    }
}
