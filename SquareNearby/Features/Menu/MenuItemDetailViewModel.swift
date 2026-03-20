import Foundation

@Observable
final class MenuItemDetailViewModel {

    // MARK: - State

    private(set) var menuItem: MenuItem?
    var quantity: Int = 1
    var selectedCustomizations: [UUID: Set<UUID>] = [:]
    private(set) var isLoading: Bool = false
    private(set) var error: Error?

    // MARK: - Initialization

    /// Initialize with a pre-loaded menu item (e.g., from a list).
    init(menuItem: MenuItem? = nil) {
        self.menuItem = menuItem
        if let item = menuItem {
            initializeCustomizations(for: item)
        }
    }

    // MARK: - Loading

    /// Fetches the full detail for a menu item by ID.
    func loadItem(id: String, using menuService: any MenuServiceProtocol) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            guard let uuid = UUID(uuidString: id) else {
                throw ServiceError.invalidInput("Invalid menu item ID")
            }
            let item = try await menuService.fetchMenuItem(id: uuid)
            menuItem = item
            initializeCustomizations(for: item)
        } catch {
            self.error = error
        }

        isLoading = false
    }

    // MARK: - Customization Selection

    func toggleOption(_ optionId: UUID, in customizationId: UUID) {
        guard let item = menuItem,
              let customization = item.customizations.first(where: { $0.id == customizationId }) else {
            return
        }

        var current = selectedCustomizations[customizationId] ?? []

        if customization.allowsMultipleSelections {
            if current.contains(optionId) {
                current.remove(optionId)
            } else if current.count < customization.maxSelections {
                current.insert(optionId)
            }
        } else {
            // Single selection: replace
            current = [optionId]
        }

        selectedCustomizations[customizationId] = current
    }

    func isOptionSelected(_ optionId: UUID, in customizationId: UUID) -> Bool {
        selectedCustomizations[customizationId]?.contains(optionId) ?? false
    }

    // MARK: - Quantity

    func incrementQuantity() {
        quantity = min(quantity + 1, 99)
    }

    func decrementQuantity() {
        quantity = max(quantity - 1, 1)
    }

    // MARK: - Computed Pricing

    /// Total price in cents for current quantity and customizations.
    var totalPriceCents: Int {
        guard let item = menuItem else { return 0 }

        let customizationCost = selectedCustomizationOptions.reduce(0) { $0 + $1.additionalPriceCents }
        return (item.priceCents + customizationCost) * quantity
    }

    var formattedTotal: String {
        totalPriceCents.formattedAsCurrency
    }

    /// Flat array of selected CustomizationOption values.
    var selectedCustomizationOptions: [CustomizationOption] {
        guard let item = menuItem else { return [] }

        var options: [CustomizationOption] = []
        for customization in item.customizations {
            let selectedIds = selectedCustomizations[customization.id] ?? []
            for option in customization.options where selectedIds.contains(option.id) {
                options.append(option)
            }
        }
        return options
    }

    /// Whether all required customizations have been selected.
    var isValid: Bool {
        guard let item = menuItem else { return false }
        for customization in item.requiredCustomizations {
            let selected = selectedCustomizations[customization.id] ?? []
            if selected.isEmpty { return false }
        }
        return true
    }

    // MARK: - Add to Cart

    func addToCart(cartManager: CartManager, merchantName: String = "") {
        guard let item = menuItem else { return }

        cartManager.addItem(
            item,
            quantity: quantity,
            customizations: selectedCustomizationOptions,
            merchantName: merchantName
        )
    }

    // MARK: - Private

    private func initializeCustomizations(for item: MenuItem) {
        selectedCustomizations = [:]
        for customization in item.customizations {
            selectedCustomizations[customization.id] = []
        }
    }
}
