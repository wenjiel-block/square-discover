import Foundation

@Observable
final class CheckoutViewModel {

    // MARK: - State

    var selectedPickupTime: Date = .now
    var paymentMethod: String = "applePay"
    private(set) var isProcessing: Bool = false
    private(set) var order: Order?
    private(set) var error: Error?

    /// Whether the user has selected ASAP pickup (the first slot).
    var isASAP: Bool = true

    // MARK: - Pickup Time Slots

    /// Generates available pickup time slots starting from the next 15-minute increment.
    var availablePickupTimeSlots: [Date] {
        let calendar = Calendar.current
        let now = Date.now

        // Round up to next 15-minute increment
        let minute = calendar.component(.minute, from: now)
        let roundedMinute = ((minute / 15) + 1) * 15
        guard let baseTime = calendar.date(
            bySettingHour: calendar.component(.hour, from: now),
            minute: 0,
            second: 0,
            of: now
        ) else {
            return []
        }

        guard let startTime = calendar.date(byAdding: .minute, value: roundedMinute, to: baseTime) else {
            return []
        }

        // Generate slots for the next 2 hours in 15-minute increments
        var slots: [Date] = []
        for i in 0..<8 {
            if let slot = calendar.date(byAdding: .minute, value: i * 15, to: startTime) {
                slots.append(slot)
            }
        }
        return slots
    }

    /// The pickup time to use for the order: nil for ASAP, or the selected time.
    var effectivePickupTime: Date? {
        isASAP ? nil : selectedPickupTime
    }

    // MARK: - Place Order

    /// Places an order using the provided order service and cart data.
    func placeOrder(using orderService: any OrderServiceProtocol, cart: Cart) async {
        guard !isProcessing else { return }
        guard let merchantId = cart.merchantId else { return }

        isProcessing = true
        error = nil

        do {
            let lineItems = cart.items.map { cartItem in
                OrderLineItem(
                    menuItemId: cartItem.menuItem.id,
                    quantity: cartItem.quantity
                )
            }

            let placedOrder = try await orderService.placeOrder(
                merchantId: merchantId,
                items: lineItems,
                pickupTime: effectivePickupTime
            )

            self.order = placedOrder
        } catch {
            self.error = error
        }

        isProcessing = false
    }

    // MARK: - Payment Methods

    static let paymentMethods: [(id: String, name: String, icon: String)] = [
        ("applePay", "Apple Pay", "apple.logo"),
        ("creditCard", "Credit Card", "creditcard.fill"),
    ]

    /// Display label for the currently selected payment method.
    var selectedPaymentMethodName: String {
        Self.paymentMethods.first(where: { $0.id == paymentMethod })?.name ?? "Payment"
    }
}
