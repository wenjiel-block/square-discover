import SwiftUI

struct NotificationsView: View {
    @State private var viewModel = NotificationsViewModel()
    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.notifications.isEmpty {
                LoadingView(message: "Loading notifications...")
            } else if let error = viewModel.error, viewModel.notifications.isEmpty {
                ErrorView(message: error) {
                    Task {
                        await viewModel.loadNotifications(using: services.notificationService)
                    }
                }
            } else if viewModel.notifications.isEmpty {
                EmptyStateView(
                    systemImage: "bell.slash",
                    title: "No Notifications",
                    subtitle: "You're all caught up!"
                )
            } else {
                List {
                    ForEach(viewModel.notifications) { notification in
                        NotificationRow(notification: notification)
                            .onTapGesture {
                                handleNotificationTap(notification)
                            }
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.loadNotifications(using: services.notificationService)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.hasUnread {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mark All Read") {
                        Task {
                            await viewModel.markAllAsRead(using: services.notificationService)
                        }
                    }
                    .font(.subheadline)
                }
            }
        }
        .task {
            await viewModel.loadNotifications(using: services.notificationService)
        }
    }

    private func handleNotificationTap(_ notification: AppNotification) {
        // Mark as read
        Task {
            await viewModel.markAsRead(id: notification.id, using: services.notificationService)
        }

        // Navigate via deep link
        guard let deepLink = notification.deepLink,
              let url = URL(string: deepLink) else {
            return
        }

        let handler = DeepLinkHandler()
        if let route = handler.handle(url) {
            router.push(route)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
            .environment(\.services, .mock)
            .environment(Router())
    }
}
