import Foundation

final class DeepLinkHandler {

    /// Parses a deep link URL into a navigation route.
    ///
    /// Supported URL schemes:
    /// - `squarenearby://merchant/{merchantId}`
    /// - `squarenearby://merchant/{merchantId}/menu`
    /// - `squarenearby://menu-item/{itemId}/merchant/{merchantId}`
    /// - `squarenearby://cart`
    /// - `squarenearby://checkout`
    /// - `squarenearby://order/{orderId}`
    /// - `squarenearby://order/{orderId}/tracking`
    /// - `squarenearby://order/{orderId}/confirmation`
    /// - `squarenearby://orders`
    /// - `squarenearby://create-post`
    /// - `squarenearby://comments/{feedItemId}`
    /// - `squarenearby://review/{merchantId}`
    /// - `squarenearby://user/{userId}`
    /// - `squarenearby://favorites`
    /// - `squarenearby://settings`
    /// - `squarenearby://edit-profile`
    /// - `squarenearby://notifications`
    func handle(_ url: URL) -> Route? {
        guard let host = url.host() else { return nil }
        let pathComponents = url.pathComponents.filter { $0 != "/" }

        switch host {
        case "merchant":
            guard let merchantId = pathComponents.first else { return nil }
            if pathComponents.count > 1, pathComponents[1] == "menu" {
                return .merchantMenu(merchantId: merchantId)
            }
            return .merchantProfile(merchantId: merchantId)

        case "menu-item":
            guard pathComponents.count >= 3,
                  pathComponents[1] == "merchant" else { return nil }
            let itemId = pathComponents[0]
            let merchantId = pathComponents[2]
            return .menuItemDetail(itemId: itemId, merchantId: merchantId)

        case "cart":
            return .cart

        case "checkout":
            return .checkout

        case "order":
            guard let orderId = pathComponents.first else { return nil }
            if pathComponents.count > 1 {
                switch pathComponents[1] {
                case "tracking":
                    return .orderTracking(orderId: orderId)
                case "confirmation":
                    return .orderConfirmation(orderId: orderId)
                default:
                    return .orderDetail(orderId: orderId)
                }
            }
            return .orderDetail(orderId: orderId)

        case "orders":
            return .orderHistory

        case "create-post":
            return .createPost

        case "comments":
            guard let feedItemId = pathComponents.first else { return nil }
            return .comments(feedItemId: feedItemId)

        case "review":
            guard let merchantId = pathComponents.first else { return nil }
            return .writeReview(merchantId: merchantId)

        case "user":
            guard let userId = pathComponents.first else { return nil }
            return .userProfile(userId: userId)

        case "favorites":
            return .favorites

        case "settings":
            return .settings

        case "edit-profile":
            return .editProfile

        case "notifications":
            return .notifications

        default:
            return nil
        }
    }
}
