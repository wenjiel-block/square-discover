import SwiftUI

struct ProfileView: View {
    let userId: UUID?
    @State private var viewModel = ProfileViewModel()
    @State private var selectedTab: ProfileTab = .posts
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @Environment(Router.self) private var router

    private var resolvedUserId: UUID {
        userId ?? appState.currentUser?.id ?? UUID()
    }

    private var isOwnProfile: Bool {
        userId == nil || userId == appState.currentUser?.id
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.profile == nil {
                    LoadingView(message: "Loading profile...")
                        .frame(height: 300)
                } else if let error = viewModel.error, viewModel.profile == nil {
                    ErrorView(message: error) {
                        Task {
                            await viewModel.loadProfile(
                                userId: resolvedUserId,
                                using: services.userService
                            )
                        }
                    }
                } else if let profile = viewModel.profile {
                    ProfileHeaderView(
                        profile: profile,
                        isOwnProfile: isOwnProfile,
                        onEditProfile: {
                            router.push(.editProfile)
                        },
                        onFollow: {
                            Task {
                                try? await services.userService.followUser(profile.id)
                            }
                        }
                    )

                    // Segmented Picker
                    Picker("Content", selection: $selectedTab) {
                        ForEach(ProfileTab.allCases, id: \.self) { tab in
                            Text(tab.title).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, Constants.Layout.horizontalPadding)
                    .padding(.vertical, 16)

                    // Content based on selection
                    switch selectedTab {
                    case .posts:
                        UserContentGrid(feedItems: viewModel.userFeedItems)
                    case .favorites:
                        FavoritesView()
                    case .orders:
                        OrderHistoryView()
                    }
                }
            }
        }
        .navigationTitle(isOwnProfile ? "My Profile" : "Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isOwnProfile {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        router.push(.settings)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .task {
            await viewModel.loadProfile(userId: resolvedUserId, using: services.userService)
            await viewModel.loadContent(userId: resolvedUserId, using: services.userService)
        }
    }
}

// MARK: - Profile Tab

enum ProfileTab: String, CaseIterable {
    case posts
    case favorites
    case orders

    var title: String {
        switch self {
        case .posts: return "Posts"
        case .favorites: return "Favorites"
        case .orders: return "Orders"
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(userId: nil)
            .environment(\.services, .mock)
            .environment(AppState())
            .environment(Router())
    }
}
