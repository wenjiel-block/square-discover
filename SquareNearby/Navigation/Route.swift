import Foundation

enum Route: Hashable {
    case merchantProfile(merchantId: String)
    case merchantMenu(merchantId: String)
    case menuItemDetail(itemId: String, merchantId: String)
    case cart
    case checkout
    case orderConfirmation(orderId: String)
    case orderTracking(orderId: String)
    case orderDetail(orderId: String)
    case orderHistory
    case createPost
    case comments(feedItemId: String)
    case writeReview(merchantId: String)
    case userProfile(userId: String)
    case favorites
    case settings
    case editProfile
    case notifications
}
