import Foundation
import SwiftUI

@Observable
final class ServiceContainer: @unchecked Sendable {
    let feedService: any FeedServiceProtocol
    let merchantService: any MerchantServiceProtocol
    let menuService: any MenuServiceProtocol
    let orderService: any OrderServiceProtocol
    let userService: any UserServiceProtocol
    let authService: any AuthServiceProtocol
    let reviewService: any ReviewServiceProtocol
    let contentService: any ContentServiceProtocol
    let notificationService: any NotificationServiceProtocol
    let locationService: any LocationServiceProtocol
    let mediaService: any MediaServiceProtocol
    let favoritesService: any FavoritesServiceProtocol

    let cartManager: CartManager

    init(useMocks: Bool) {
        self.cartManager = CartManager()

        if useMocks {
            let store = MockDataStore()

            self.feedService = MockFeedService(store: store)
            self.merchantService = MockMerchantService(store: store)
            self.menuService = MockMenuService(store: store)
            self.orderService = MockOrderService(store: store)
            self.userService = MockUserService(store: store)
            self.authService = MockAuthService(store: store)
            self.reviewService = MockReviewService(store: store)
            self.contentService = MockContentService(store: store)
            self.notificationService = MockNotificationService(store: store)
            self.locationService = MockLocationService()
            self.mediaService = MockMediaService()
            self.favoritesService = MockFavoritesService(store: store)
        } else {
            // Live services -- placeholder stubs that use mock implementations for now.
            // Replace these with real network-backed services when the API layer is ready.
            let store = MockDataStore()

            self.feedService = MockFeedService(store: store)
            self.merchantService = MockMerchantService(store: store)
            self.menuService = MockMenuService(store: store)
            self.orderService = MockOrderService(store: store)
            self.userService = MockUserService(store: store)
            self.authService = MockAuthService(store: store)
            self.reviewService = MockReviewService(store: store)
            self.contentService = MockContentService(store: store)
            self.notificationService = MockNotificationService(store: store)
            self.locationService = MockLocationService()
            self.mediaService = MockMediaService()
            self.favoritesService = MockFavoritesService(store: store)
        }
    }

    /// A convenience mock container for previews and testing.
    static let mock = ServiceContainer(useMocks: true)
}

// MARK: - SwiftUI Environment Integration

private struct ServiceContainerKey: EnvironmentKey {
    static let defaultValue: ServiceContainer = .mock
}

extension EnvironmentValues {
    var services: ServiceContainer {
        get { self[ServiceContainerKey.self] }
        set { self[ServiceContainerKey.self] = newValue }
    }
}
