import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .feed
    @State private var showCreatePost = false

    @State private var feedRouter = Router()
    @State private var discoverRouter = Router()
    @State private var ordersRouter = Router()
    @State private var profileRouter = Router()

    var body: some View {
        TabView(selection: tabSelection) {
            feedTab
            discoverTab
            createPostTab
            ordersTab
            profileTab
        }
        .fullScreenCover(isPresented: $showCreatePost) {
            CreatePostView()
        }
    }

    // MARK: - Tab Selection Binding

    private var tabSelection: Binding<TabItem> {
        Binding<TabItem>(
            get: { selectedTab },
            set: { newTab in
                if newTab == .createPost {
                    showCreatePost = true
                } else {
                    selectedTab = newTab
                }
            }
        )
    }

    // MARK: - Tabs

    private var feedTab: some View {
        NavigationStack(path: $feedRouter.path) {
            FeedView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(feedRouter)
        .tabItem {
            Label(TabItem.feed.title, systemImage: TabItem.feed.systemImage)
        }
        .tag(TabItem.feed)
    }

    private var discoverTab: some View {
        NavigationStack(path: $discoverRouter.path) {
            DiscoveryView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(discoverRouter)
        .tabItem {
            Label(TabItem.discover.title, systemImage: TabItem.discover.systemImage)
        }
        .tag(TabItem.discover)
    }

    private var createPostTab: some View {
        Text("")
            .tabItem {
                Label(TabItem.createPost.title, systemImage: TabItem.createPost.systemImage)
            }
            .tag(TabItem.createPost)
    }

    private var ordersTab: some View {
        NavigationStack(path: $ordersRouter.path) {
            OrderHistoryView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(ordersRouter)
        .tabItem {
            Label(TabItem.orders.title, systemImage: TabItem.orders.systemImage)
        }
        .tag(TabItem.orders)
    }

    private var profileTab: some View {
        NavigationStack(path: $profileRouter.path) {
            ProfileView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(profileRouter)
        .tabItem {
            Label(TabItem.profile.title, systemImage: TabItem.profile.systemImage)
        }
        .tag(TabItem.profile)
    }

    // MARK: - Destination View

    @ViewBuilder
    func destinationView(for route: Route) -> some View {
        switch route {
        case .merchantProfile(let merchantId):
            MerchantProfileView(merchantId: merchantId)
        case .merchantMenu(let merchantId):
            MenuView(merchantId: merchantId)
        case .menuItemDetail(let itemId, let merchantId):
            MenuItemDetailView(itemId: itemId, merchantId: merchantId)
        case .cart:
            CartView()
        case .checkout:
            CheckoutView()
        case .orderConfirmation(let orderId):
            OrderConfirmationView(orderId: orderId)
        case .orderTracking(let orderId):
            OrderTrackingView(orderId: orderId)
        case .orderDetail(let orderId):
            OrderDetailView(orderId: orderId)
        case .orderHistory:
            OrderHistoryView()
        case .createPost:
            CreatePostView()
        case .comments(let feedItemId):
            CommentsView(feedItemId: feedItemId)
        case .writeReview(let merchantId):
            WriteReviewView(merchantId: merchantId)
        case .userProfile(let userId):
            ProfileView(userId: userId)
        case .favorites:
            FavoritesView()
        case .settings:
            SettingsView()
        case .editProfile:
            SettingsView()
        case .notifications:
            NotificationsView()
        }
    }
}

#Preview {
    MainTabView()
}
