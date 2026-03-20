import SwiftUI

struct OrderStatusTimeline: View {
    let currentStatus: OrderStatus
    let statuses: [OrderStatus]
    let createdAt: Date

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(statuses.enumerated()), id: \.element) { index, status in
                timelineStep(
                    status: status,
                    isCompleted: status.sortOrder <= currentStatus.sortOrder,
                    isCurrent: status == currentStatus,
                    isLast: index == statuses.count - 1,
                    timestamp: estimatedTimestamp(for: status)
                )
            }
        }
    }

    // MARK: - Timeline Step

    private func timelineStep(
        status: OrderStatus,
        isCompleted: Bool,
        isCurrent: Bool,
        isLast: Bool,
        timestamp: String?
    ) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon and connector line
            VStack(spacing: 0) {
                // Status circle/icon
                ZStack {
                    if isCompleted {
                        Circle()
                            .fill(isCurrent ? Color.brandPrimary : .green)
                            .frame(width: 32, height: 32)

                        Image(systemName: isCurrent ? status.systemImage : "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                    } else {
                        Circle()
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 2)
                            .frame(width: 32, height: 32)

                        Image(systemName: status.systemImage)
                            .font(.caption)
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                }

                // Connector line
                if !isLast {
                    Rectangle()
                        .fill(isCompleted ? Color.green : Color.secondary.opacity(0.2))
                        .frame(width: 2, height: 40)
                }
            }

            // Label and timestamp
            VStack(alignment: .leading, spacing: 2) {
                Text(status.displayName)
                    .font(isCurrent ? .body.weight(.bold) : .body)
                    .foregroundStyle(isCompleted ? .primary : .secondary)

                if let timestamp {
                    Text(timestamp)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if isCurrent && status != .pickedUp && status != .cancelled {
                    Text("Current")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.brandPrimary)
                        .padding(.top, 2)
                }
            }
            .padding(.top, 4)

            Spacer()
        }
    }

    // MARK: - Timestamp Estimation

    /// Generates estimated timestamps for each status based on the order creation time.
    private func estimatedTimestamp(for status: OrderStatus) -> String? {
        let calendar = Calendar.current

        guard status.sortOrder <= currentStatus.sortOrder else {
            return nil
        }

        // Approximate timestamps relative to creation time
        let minutesOffset: Int
        switch status {
        case .placed: minutesOffset = 0
        case .confirmed: minutesOffset = 2
        case .preparing: minutesOffset = 5
        case .ready: minutesOffset = 15
        case .pickedUp: minutesOffset = 20
        case .cancelled: minutesOffset = 1
        }

        guard let date = calendar.date(byAdding: .minute, value: minutesOffset, to: createdAt) else {
            return nil
        }

        return timeFormatter.string(from: date)
    }
}

#Preview("Active Order") {
    ScrollView {
        OrderStatusTimeline(
            currentStatus: .preparing,
            statuses: [.placed, .confirmed, .preparing, .ready, .pickedUp],
            createdAt: .now.addingTimeInterval(-300)
        )
        .padding()
    }
}

#Preview("Completed Order") {
    ScrollView {
        OrderStatusTimeline(
            currentStatus: .pickedUp,
            statuses: [.placed, .confirmed, .preparing, .ready, .pickedUp],
            createdAt: .now.addingTimeInterval(-1200)
        )
        .padding()
    }
}

#Preview("Cancelled Order") {
    ScrollView {
        OrderStatusTimeline(
            currentStatus: .cancelled,
            statuses: [.placed, .cancelled],
            createdAt: .now.addingTimeInterval(-60)
        )
        .padding()
    }
}
