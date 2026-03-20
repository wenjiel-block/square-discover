import SwiftUI

struct ActiveOrderBanner: View {
    let order: Order
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Status icon with pulsing animation
                statusIcon

                // Order info
                VStack(alignment: .leading, spacing: 2) {
                    Text(order.merchantName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(order.status.displayName)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }

                Spacer()

                // Pickup time or chevron
                if let pickupTime = order.formattedPickupTime {
                    Text(pickupTime)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.2), in: Capsule())
                } else if let estimatedReady = order.formattedEstimatedReadyAt {
                    Text(estimatedReady)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(bannerGradient, in: RoundedRectangle(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Active order at \(order.merchantName), status: \(order.status.displayName)")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Subviews

    private var statusIcon: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: 36, height: 36)

            Image(systemName: order.status.systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
        }
    }

    private var bannerGradient: LinearGradient {
        let color: Color = {
            switch order.status {
            case .placed, .confirmed:
                return .brandPrimary
            case .preparing:
                return .orange
            case .ready:
                return .green
            case .pickedUp, .cancelled:
                return .secondary
            }
        }()

        return LinearGradient(
            colors: [color, color.opacity(0.85)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        ActiveOrderBanner(
            order: Order(
                merchantId: UUID(),
                merchantName: "Sakura Sushi",
                items: [],
                status: .preparing,
                subtotalCents: 2990,
                taxCents: 262,
                totalCents: 3252,
                estimatedReadyAt: Calendar.current.date(byAdding: .minute, value: 12, to: .now)
            ),
            onTap: {}
        )

        ActiveOrderBanner(
            order: Order(
                merchantId: UUID(),
                merchantName: "Corner Cafe",
                items: [],
                status: .ready,
                subtotalCents: 1495,
                taxCents: 131,
                totalCents: 1626,
                pickupTime: Calendar.current.date(byAdding: .minute, value: 5, to: .now)
            ),
            onTap: {}
        )

        ActiveOrderBanner(
            order: Order(
                merchantId: UUID(),
                merchantName: "Taco Bell",
                items: [],
                status: .placed,
                subtotalCents: 899,
                taxCents: 79,
                totalCents: 978
            ),
            onTap: {}
        )
    }
    .padding()
}
