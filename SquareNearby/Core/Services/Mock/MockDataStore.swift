import Foundation
import SwiftUI

@Observable
final class MockDataStore: @unchecked Sendable {
    var merchants: [Merchant]
    var menuCategories: [String: [MenuCategory]]
    var feedItems: [FeedItem]
    var orders: [Order]
    var currentUser: User?
    var favoriteMerchantIds: Set<String>
    var favoriteMenuItemIds: Set<String>
    var likedFeedItemIds: Set<String>
    var savedFeedItemIds: Set<String>
    var notifications: [AppNotification]
    var reviews: [String: [Review]]

    init() {
        self.merchants = MockMerchants.all
        self.menuCategories = MockMenuItems.byMerchant
        self.feedItems = MockFeedItems.all
        self.orders = MockOrders.all
        self.currentUser = MockUsers.loggedInUser
        self.favoriteMerchantIds = Set([
            MockMerchants.laTaqueriaId.uuidString,
            MockMerchants.sakuraRamenId.uuidString,
            MockMerchants.nonnasKitchenId.uuidString,
        ])
        self.favoriteMenuItemIds = Set()
        self.likedFeedItemIds = Set()
        self.savedFeedItemIds = Set()
        self.notifications = MockNotifications.all
        self.reviews = MockReviews.byMerchant
    }
}
