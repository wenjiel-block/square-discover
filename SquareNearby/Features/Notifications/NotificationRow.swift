import SwiftUI

struct NotificationRow: View {
    let notification: AppNotification

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Type Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: notification.type.systemImage)
                    .font(.subheadline)
                    .foregroundStyle(iconBackgroundColor)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.subheadline.weight(notification.isRead ? .regular : .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(notification.body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(notification.timeAgo)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            // Unread Indicator
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)
            }
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.vertical, 12)
        .background(notification.isRead ? Color.clear : Color.blue.opacity(0.03))
        .contentShape(Rectangle())
    }

    private var iconBackgroundColor: Color {
        switch notification.type {
        case .orderUpdate:
            return .orange
        case .newContent:
            return Color.brandPrimary
        case .newFollower:
            return .blue
        case .newLike:
            return .red
        case .newComment:
            return .green
        case .promotion:
            return .purple
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        NotificationRow(
            notification: AppNotification(
                type: .newLike,
                title: "Jane liked your post",
                body: "Jane Doe liked your photo at Blue Bottle Coffee.",
                isRead: false,
                createdAt: Date.now.addingTimeInterval(-3600)
            )
        )

        Divider()

        NotificationRow(
            notification: AppNotification(
                type: .orderUpdate,
                title: "Order Ready",
                body: "Your order at Tartine Bakery is ready for pickup.",
                isRead: true,
                createdAt: Date.now.addingTimeInterval(-7200)
            )
        )

        Divider()

        NotificationRow(
            notification: AppNotification(
                type: .newFollower,
                title: "New Follower",
                body: "Alex started following you.",
                isRead: false,
                createdAt: Date.now.addingTimeInterval(-86400)
            )
        )
    }
}
