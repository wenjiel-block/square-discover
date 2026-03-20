import Foundation

struct OrderItem: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let menuItem: MenuItem
    let quantity: Int
    let selectedCustomizations: [CustomizationOption]
    let specialInstructions: String?

    init(
        id: UUID = UUID(),
        menuItem: MenuItem,
        quantity: Int = 1,
        selectedCustomizations: [CustomizationOption] = [],
        specialInstructions: String? = nil
    ) {
        self.id = id
        self.menuItem = menuItem
        self.quantity = quantity
        self.selectedCustomizations = selectedCustomizations
        self.specialInstructions = specialInstructions
    }

    var totalPriceCents: Int {
        let customizationsCost = selectedCustomizations.reduce(0) { $0 + $1.additionalPriceCents }
        return (menuItem.priceCents + customizationsCost) * quantity
    }

    var formattedTotalPrice: String {
        let dollars = Double(totalPriceCents) / 100.0
        return String(format: "$%.2f", dollars)
    }
}

struct Order: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let merchantId: UUID
    let merchantName: String
    let items: [OrderItem]
    var status: OrderStatus
    let subtotalCents: Int
    let taxCents: Int
    let totalCents: Int
    let pickupTime: Date?
    let createdAt: Date
    var estimatedReadyAt: Date?

    init(
        id: UUID = UUID(),
        merchantId: UUID,
        merchantName: String,
        items: [OrderItem],
        status: OrderStatus = .placed,
        subtotalCents: Int,
        taxCents: Int,
        totalCents: Int,
        pickupTime: Date? = nil,
        createdAt: Date = .now,
        estimatedReadyAt: Date? = nil
    ) {
        self.id = id
        self.merchantId = merchantId
        self.merchantName = merchantName
        self.items = items
        self.status = status
        self.subtotalCents = subtotalCents
        self.taxCents = taxCents
        self.totalCents = totalCents
        self.pickupTime = pickupTime
        self.createdAt = createdAt
        self.estimatedReadyAt = estimatedReadyAt
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

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var isActive: Bool {
        status.isActive
    }

    var formattedPickupTime: String? {
        guard let pickupTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: pickupTime)
    }

    var formattedEstimatedReadyAt: String? {
        guard let estimatedReadyAt else { return nil }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: estimatedReadyAt, relativeTo: .now)
    }

    var formattedCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }

    private static func formatCents(_ cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        return String(format: "$%.2f", dollars)
    }
}
