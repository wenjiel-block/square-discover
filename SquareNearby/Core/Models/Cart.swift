import Foundation
import SwiftUI

struct CartItem: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let menuItem: MenuItem
    var quantity: Int
    let selectedCustomizations: [CustomizationOption]

    init(
        id: UUID = UUID(),
        menuItem: MenuItem,
        quantity: Int = 1,
        selectedCustomizations: [CustomizationOption] = []
    ) {
        self.id = id
        self.menuItem = menuItem
        self.quantity = quantity
        self.selectedCustomizations = selectedCustomizations
    }

    var totalPriceCents: Int {
        let customizationsCost = selectedCustomizations.reduce(0) { $0 + $1.additionalPriceCents }
        return (menuItem.priceCents + customizationsCost) * quantity
    }

    var formattedTotalPrice: String {
        let dollars = Double(totalPriceCents) / 100.0
        return String(format: "$%.2f", dollars)
    }

    var formattedUnitPrice: String {
        let customizationsCost = selectedCustomizations.reduce(0) { $0 + $1.additionalPriceCents }
        let unitCents = menuItem.priceCents + customizationsCost
        let dollars = Double(unitCents) / 100.0
        return String(format: "$%.2f", dollars)
    }
}

@Observable
final class Cart: @unchecked Sendable {
    private static let taxRate = 0.0875

    var merchantId: UUID?
    var items: [CartItem] = []

    init(merchantId: UUID? = nil, items: [CartItem] = []) {
        self.merchantId = merchantId
        self.items = items
    }

    var subtotalCents: Int {
        items.reduce(0) { $0 + $1.totalPriceCents }
    }

    var taxCents: Int {
        Int(round(Double(subtotalCents) * Self.taxRate))
    }

    var totalCents: Int {
        subtotalCents + taxCents
    }

    var isEmpty: Bool {
        items.isEmpty
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var formattedSubtotal: String {
        Self.formatCents(subtotalCents)
    }

    var formattedTax: String {
        Self.formatCents(taxCents)
    }

    var formattedTotal: String {
        Self.formatCents(totalCents)
    }

    func addItem(_ menuItem: MenuItem, quantity: Int = 1, customizations: [CustomizationOption] = []) {
        if merchantId == nil {
            merchantId = menuItem.merchantId
        }

        guard merchantId == menuItem.merchantId else { return }

        let cartItem = CartItem(
            menuItem: menuItem,
            quantity: quantity,
            selectedCustomizations: customizations
        )
        items.append(cartItem)
    }

    func removeItem(_ cartItem: CartItem) {
        items.removeAll { $0.id == cartItem.id }
        if items.isEmpty {
            merchantId = nil
        }
    }

    func updateQuantity(for cartItem: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == cartItem.id }) else { return }
        if quantity <= 0 {
            items.remove(at: index)
            if items.isEmpty {
                merchantId = nil
            }
        } else {
            items[index].quantity = quantity
        }
    }

    func clear() {
        items.removeAll()
        merchantId = nil
    }

    private static func formatCents(_ cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        return String(format: "$%.2f", dollars)
    }
}
