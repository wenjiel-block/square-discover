import SwiftUI

struct OrderConfirmationView: View {
    let orderId: String

    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    @State private var order: Order?
    @State private var isLoading = true
    @State private var showCheckmark = false

    var body: some View {
        Group {
            if isLoading {
                LoadingView(message: "Loading order...")
            } else {
                confirmationContent
            }
        }
        .navigationTitle("Order Confirmed")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .task {
            await loadOrder()
        }
    }

    // MARK: - Confirmation Content

    private var confirmationContent: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Success animation
                successIcon

                // Order details
                orderDetails

                // Action buttons
                actionButtons
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.vertical, 32)
        }
    }

    // MARK: - Success Icon

    private var successIcon: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 100, height: 100)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)
                    .scaleEffect(showCheckmark ? 1.0 : 0.3)
                    .opacity(showCheckmark ? 1.0 : 0.0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showCheckmark = true
                }
            }

            Text("Order Placed!")
                .font(.title2.weight(.bold))

            Text("Your order has been sent to the merchant.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Order Details

    @ViewBuilder
    private var orderDetails: some View {
        if let order {
            VStack(spacing: 16) {
                detailRow(label: "Order Number", value: "#\(order.id.uuidString.prefix(8).uppercased())")

                detailRow(label: "Merchant", value: order.merchantName)

                if let pickupTime = order.formattedPickupTime {
                    detailRow(label: "Pickup Time", value: pickupTime)
                } else if let estimatedReady = order.formattedEstimatedReadyAt {
                    detailRow(label: "Estimated Ready", value: estimatedReady)
                }

                detailRow(label: "Total", value: order.formattedTotal)

                // Items summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Items")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)

                    ForEach(order.items) { item in
                        HStack {
                            Text("\(item.quantity)x \(item.menuItem.name)")
                                .font(.subheadline)
                                .lineLimit(1)

                            Spacer()

                            Text(item.formattedTotalPrice)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(Constants.Layout.horizontalPadding)
            .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.medium))
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                router.push(.orderTracking(orderId: orderId))
            } label: {
                Label("Track Order", systemImage: "location.fill")
                    .font(.body.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 14))
            }

            Button {
                router.popToRoot()
            } label: {
                Text("Back to Feed")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.brandPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.brandPrimary.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    // MARK: - Data Loading

    private func loadOrder() async {
        guard let uuid = UUID(uuidString: orderId) else {
            isLoading = false
            return
        }

        do {
            order = try await services.orderService.fetchOrder(id: uuid)
        } catch {
            // Show confirmation even without full order details
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        OrderConfirmationView(orderId: UUID().uuidString)
            .environment(\.services, .mock)
            .environment(Router())
    }
}
