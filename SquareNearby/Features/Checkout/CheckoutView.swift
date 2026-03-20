import SwiftUI

struct CheckoutView: View {
    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    @State private var viewModel = CheckoutViewModel()

    var body: some View {
        Group {
            if viewModel.isProcessing {
                processingView
            } else {
                checkoutContent
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Checkout Content

    private var checkoutContent: some View {
        let cartManager = services.cartManager
        let cart = cartManager.cart

        return VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.Layout.sectionSpacing) {
                    // Order summary
                    orderSummarySection(cart: cart)

                    Divider()

                    // Pickup time
                    pickupTimeSection

                    Divider()

                    // Payment method
                    paymentSection

                    // Error message
                    if let error = viewModel.error {
                        errorBanner(error)
                    }
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
                .padding(.vertical, 16)
            }

            Divider()

            // Place order button
            placeOrderButton(cart: cart)
        }
    }

    // MARK: - Order Summary

    private func orderSummarySection(cart: Cart) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)

            ForEach(cart.items) { item in
                HStack {
                    Text("\(item.quantity)x")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(width: 28, alignment: .leading)

                    Text(item.menuItem.name)
                        .font(.subheadline)
                        .lineLimit(1)

                    Spacer()

                    Text(item.formattedTotalPrice)
                        .font(.subheadline.weight(.medium))
                }

                if !item.selectedCustomizations.isEmpty {
                    Text(item.selectedCustomizations.map(\.name).joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 28)
                }
            }

            Divider()

            CartSummaryView(
                subtotal: cart.formattedSubtotal,
                tax: cart.formattedTax,
                total: cart.formattedTotal
            )
        }
    }

    // MARK: - Pickup Time

    private var pickupTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pickup Time")
                .font(.headline)

            PickupTimeSelector(
                timeSlots: viewModel.availablePickupTimeSlots,
                selectedTime: $viewModel.selectedPickupTime,
                isASAP: $viewModel.isASAP
            )
        }
    }

    // MARK: - Payment

    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment")
                .font(.headline)

            PaymentMethodView(
                selectedMethod: $viewModel.paymentMethod
            )
        }
    }

    // MARK: - Error Banner

    private func errorBanner(_ error: Error) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.brandAccent)

            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandAccent.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Place Order Button

    private func placeOrderButton(cart: Cart) -> some View {
        VStack(spacing: 8) {
            Button {
                Task {
                    await viewModel.placeOrder(
                        using: services.orderService,
                        cart: cart
                    )

                    if let order = viewModel.order {
                        // Clear the cart after successful order
                        services.cartManager.clearCart()
                        router.push(.orderConfirmation(orderId: order.id.uuidString))
                    }
                }
            } label: {
                HStack {
                    Text("Place Order")
                        .font(.body.weight(.bold))

                    Spacer()

                    Text(cart.formattedTotal)
                        .font(.body.weight(.bold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 14))
            }
            .disabled(cart.isEmpty)
        }
        .padding(Constants.Layout.horizontalPadding)
        .background(.ultraThinMaterial)
    }

    // MARK: - Processing

    private var processingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .controlSize(.large)

            Text("Placing your order...")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Please don't close the app")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        CheckoutView()
            .environment(\.services, .mock)
            .environment(Router())
    }
}
