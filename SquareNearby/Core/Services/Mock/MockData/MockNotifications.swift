import Foundation

struct MockNotifications {
    static let all: [AppNotification] = [
        AppNotification(
            type: .orderUpdate,
            title: "Order Ready!",
            body: "Your order from The Burger Joint is ready for pickup. Head over to grab your food!",
            imageURL: URL(string: "https://picsum.photos/seed/notif1/100/100"),
            deepLink: "squarenearby://orders/active",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .minute, value: -5, to: .now)!
        ),
        AppNotification(
            type: .newLike,
            title: "Sarah Kim liked your post",
            body: "Your post about Seoul Kitchen's bibimbap got a new like.",
            imageURL: URL(string: "https://picsum.photos/seed/user1/100/100"),
            deepLink: "squarenearby://feed/post/123",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        ),
        AppNotification(
            type: .newComment,
            title: "Marcus Johnson commented on your post",
            body: "\"That looks amazing! Where exactly is this spot?\"",
            imageURL: URL(string: "https://picsum.photos/seed/user2/100/100"),
            deepLink: "squarenearby://feed/post/123",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        ),
        AppNotification(
            type: .newFollower,
            title: "New Follower",
            body: "ramen_hunter started following you. Check out their profile!",
            imageURL: URL(string: "https://picsum.photos/seed/user3/100/100"),
            deepLink: "squarenearby://profile/ramen_hunter",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!
        ),
        AppNotification(
            type: .promotion,
            title: "20% Off at Nonna's Kitchen!",
            body: "Celebrate Nonna's 40th anniversary with 20% off all pasta dishes this weekend only.",
            imageURL: URL(string: "https://picsum.photos/seed/promo1/100/100"),
            deepLink: "squarenearby://merchant/nonnas",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .hour, value: -6, to: .now)!
        ),
        AppNotification(
            type: .orderUpdate,
            title: "Order Confirmed",
            body: "Sakura Ramen has confirmed your order. Estimated pickup time: 20 minutes.",
            imageURL: URL(string: "https://picsum.photos/seed/notif2/100/100"),
            deepLink: "squarenearby://orders/active",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!
        ),
        AppNotification(
            type: .newContent,
            title: "New post from foodie_sarah",
            body: "Sarah Kim just posted about Nonna's Kitchen. Check it out!",
            imageURL: URL(string: "https://picsum.photos/seed/user1/100/100"),
            deepLink: "squarenearby://feed",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        AppNotification(
            type: .newLike,
            title: "Your review is getting attention!",
            body: "Your review of La Taqueria has received 30 likes. Keep sharing your food adventures!",
            imageURL: URL(string: "https://picsum.photos/seed/notif3/100/100"),
            deepLink: "squarenearby://reviews",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        AppNotification(
            type: .promotion,
            title: "Free Delivery Weekend!",
            body: "Enjoy free delivery on all orders over $25 this Saturday and Sunday. Use code FREEWEEKEND.",
            imageURL: URL(string: "https://picsum.photos/seed/promo2/100/100"),
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ),
        AppNotification(
            type: .newFollower,
            title: "New Follower",
            body: "global_palate started following you.",
            imageURL: URL(string: "https://picsum.photos/seed/user8/100/100"),
            deepLink: "squarenearby://profile/global_palate",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        ),
    ]
}
