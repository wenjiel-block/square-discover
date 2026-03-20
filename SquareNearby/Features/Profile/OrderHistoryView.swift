import SwiftUI

struct OrderHistoryView: View {
    @State private var viewModel = OrderHistoryViewModel()
    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.orders.isEmpty {
                LoadingView(message: "Loading orders...")
                    .frame(height: 200)
            } else if let error = viewModel.error, viewModel.orders.isEmpty {
                ErrorView(message: error) {
                    Task {
                        await viewModel.loadOrders(using: services.orderService)
                    }
                }
            } else if viewModel.orders.isEmpty {
                EmptyStateView(
                    systemImage: "bag",
                    title: "No Orders Yet",
                    subtitle: "Your past orders will appear here."
                )
                .frame(height: 200)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.orders) { order in
                        OrderHistoryRow(order: order)
                            .onTapGesture {
                                router.push(.orderDetail(orderId: order.id.uuidString))
                            }
                    }
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
            }
        }
        .task {
            await viewModel.loadOrders(using: services.orderService)
        }
    }
}

// MARK: - Order History Row

private struct OrderHistoryRow: View {
    let order: Order

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(order.merchantName)
                    .font(.headline)

                Text(order.createdAt.shortDateString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(order.formattedTotal)
                    .font(.subheadline.weight(.semibold))

                OrderStatusBadge(status: order.status)
            }
        }
        .padding()
        .cardStyle()
    }
}

// MARK: - Order Status Badge

private struct OrderStatusBadge: View {
    let status: OrderStatus

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.systemImage)
                .font(.caption2)

            Text(status.displayName)
                .font(.caption.weight(.medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor.opacity(0.15), in: Capsule())
        .foregroundStyle(backgroundColor)
    }

    private var backgroundColor: Color {
        switch status {
        case .placed, .confirmed:
            return .blue
        case .preparing:
            return .orange
        case .ready:
            return .green
        case .pickedUp:
            return .secondary
        case .cancelled:
            return .red
        }
    }
}

#Preview {
    NavigationStack {
        OrderHistoryView()
            .environment(\.services, .mock)
            .environment(Router())
    }
}
