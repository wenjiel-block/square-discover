import SwiftUI

struct OrderTrackingView: View {
    let orderId: String

    @Environment(\.services) private var services

    @State private var viewModel = OrderTrackingViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(message: "Loading order...")
            } else if let error = viewModel.error {
                ErrorView(
                    message: "Could not load order",
                    description: error.localizedDescription,
                    retryAction: {
                        Task {
                            await viewModel.loadOrder(id: orderId, using: services.orderService)
                        }
                    }
                )
            } else if let order = viewModel.order {
                trackingContent(order)
            }
        }
        .navigationTitle("Order Status")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadOrder(id: orderId, using: services.orderService)
        }
        .onDisappear {
            viewModel.stopProgression()
        }
    }

    // MARK: - Tracking Content

    private func trackingContent(_ order: Order) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.Layout.sectionSpacing) {
                // Merchant and status header
                headerSection(order)

                // Status timeline
                OrderStatusTimeline(
                    currentStatus: order.status,
                    statuses: viewModel.timelineStatuses,
                    createdAt: order.createdAt
                )
                .padding(.horizontal, Constants.Layout.horizontalPadding)

                Divider()
                    .padding(.horizontal, Constants.Layout.horizontalPadding)

                // Pickup time
                pickupTimeSection(order)

                Divider()
                    .padding(.horizontal, Constants.Layout.horizontalPadding)

                // Order items
                itemsSummarySection(order)
            }
            .padding(.vertical, 16)
        }
        .refreshable {
            await viewModel.refreshOrder(using: services.orderService)
        }
    }

    // MARK: - Header

    private func headerSection(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(order.merchantName)
                .font(.title2.weight(.bold))

            HStack(spacing: 8) {
                Image(systemName: order.status.systemImage)
                    .foregroundStyle(statusColor(order.status))

                Text(order.status.displayName)
                    .font(.headline)
                    .foregroundStyle(statusColor(order.status))
            }

            Text("Order #\(order.id.uuidString.prefix(8).uppercased())")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
    }

    // MARK: - Pickup Time

    private func pickupTimeSection(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pickup Info")
                .font(.headline)

            if let pickupTime = order.formattedPickupTime {
                Label("Scheduled: \(pickupTime)", systemImage: "clock.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let estimatedReady = order.formattedEstimatedReadyAt {
                Label("Estimated ready: \(estimatedReady)", systemImage: "timer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text("Placed: \(order.formattedCreatedAt)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
    }

    // MARK: - Items Summary

    private func itemsSummarySection(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Items")
                .font(.headline)

            ForEach(order.items) { item in
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
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            HStack {
                Text("Total")
                    .font(.subheadline.weight(.bold))

                Spacer()

                Text(order.formattedTotal)
                    .font(.subheadline.weight(.bold))
            }
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
    }

    // MARK: - Helpers

    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .placed, .confirmed:
            return .brandPrimary
        case .preparing:
            return .orange
        case .ready:
            return .green
        case .pickedUp:
            return .secondary
        case .cancelled:
            return .brandAccent
        }
    }
}

#Preview {
    NavigationStack {
        OrderTrackingView(orderId: UUID().uuidString)
            .environment(\.services, .mock)
    }
}
