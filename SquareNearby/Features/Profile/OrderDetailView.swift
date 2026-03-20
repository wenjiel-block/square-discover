import SwiftUI

struct OrderDetailView: View {
    let orderId: String
    @State private var order: Order?
    @State private var isLoading = true
    @State private var error: String?
    @Environment(\.services) private var services

    var body: some View {
        Group {
            if isLoading && order == nil {
                LoadingView(message: "Loading order...")
            } else if let error, order == nil {
                ErrorView(message: error) {
                    Task { await loadOrder() }
                }
            } else if let order {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Merchant and Status
                        orderHeaderSection(order)

                        Divider()

                        // Items
                        orderItemsSection(order)

                        Divider()

                        // Price Breakdown
                        priceBreakdownSection(order)

                        // Pickup Time
                        if let pickupTime = order.formattedPickupTime {
                            Divider()
                            pickupTimeSection(pickupTime)
                        }
                    }
                    .padding(Constants.Layout.horizontalPadding)
                }
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadOrder() }
    }

    // MARK: - Sections

    @ViewBuilder
    private func orderHeaderSection(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.merchantName)
                        .font(.title2.weight(.bold))

                    Text(order.formattedCreatedAt)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                statusBadge(order.status)
            }
        }
    }

    @ViewBuilder
    private func orderItemsSection(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items")
                .font(.headline)

            ForEach(order.items) { item in
                HStack {
                    Text("\(item.quantity)x")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(width: 32, alignment: .leading)

                    Text(item.menuItem.name)
                        .font(.subheadline)

                    Spacer()

                    Text(item.formattedTotalPrice)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let instructions = item.specialInstructions, !instructions.isEmpty {
                    Text("Note: \(instructions)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 32)
                }
            }
        }
    }

    @ViewBuilder
    private func priceBreakdownSection(_ order: Order) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Subtotal")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(order.formattedSubtotal)
            }
            .font(.subheadline)

            HStack {
                Text("Tax")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(order.formattedTax)
            }
            .font(.subheadline)

            Divider()

            HStack {
                Text("Total")
                    .font(.headline)
                Spacer()
                Text(order.formattedTotal)
                    .font(.headline)
            }
        }
    }

    @ViewBuilder
    private func pickupTimeSection(_ pickupTime: String) -> some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundStyle(Color.brandPrimary)

            Text("Pickup Time")
                .font(.subheadline)

            Spacer()

            Text(pickupTime)
                .font(.subheadline.weight(.semibold))
        }
    }

    @ViewBuilder
    private func statusBadge(_ status: OrderStatus) -> some View {
        HStack(spacing: 4) {
            Image(systemName: status.systemImage)
                .font(.caption2)

            Text(status.displayName)
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(statusColor(status).opacity(0.15), in: Capsule())
        .foregroundStyle(statusColor(status))
    }

    // MARK: - Helpers

    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .placed, .confirmed: return .blue
        case .preparing: return .orange
        case .ready: return .green
        case .pickedUp: return .secondary
        case .cancelled: return .red
        }
    }

    @MainActor
    private func loadOrder() async {
        isLoading = true
        error = nil

        do {
            guard let uuid = UUID(uuidString: orderId) else {
                error = "Invalid order ID."
                isLoading = false
                return
            }
            order = try await services.orderService.fetchOrder(id: uuid)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(orderId: UUID().uuidString)
            .environment(\.services, .mock)
    }
}
