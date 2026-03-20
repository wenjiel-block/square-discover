import SwiftUI

struct FavoritesView: View {
    @State private var viewModel = FavoritesViewModel()
    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.merchants.isEmpty && viewModel.menuItems.isEmpty {
                LoadingView(message: "Loading favorites...")
                    .frame(height: 200)
            } else if let error = viewModel.error,
                      viewModel.merchants.isEmpty,
                      viewModel.menuItems.isEmpty {
                ErrorView(message: error) {
                    Task {
                        await viewModel.load(using: services.favoritesService)
                    }
                }
            } else if viewModel.merchants.isEmpty && viewModel.menuItems.isEmpty {
                EmptyStateView(
                    systemImage: "heart",
                    title: "No Favorites Yet",
                    subtitle: "Save merchants and items you love."
                )
                .frame(height: 200)
            } else {
                VStack(alignment: .leading, spacing: Constants.Layout.sectionSpacing) {
                    // Favorite Merchants Section
                    if !viewModel.merchants.isEmpty {
                        favoriteMerchantsSection
                    }

                    // Favorite Menu Items Section
                    if !viewModel.menuItems.isEmpty {
                        favoriteMenuItemsSection
                    }
                }
            }
        }
        .task {
            await viewModel.load(using: services.favoritesService)
        }
    }

    // MARK: - Favorite Merchants

    @ViewBuilder
    private var favoriteMerchantsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorite Merchants")
                .font(.headline)
                .padding(.horizontal, Constants.Layout.horizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.merchants) { merchant in
                        FavoriteMerchantCard(merchant: merchant)
                            .onTapGesture {
                                router.push(.merchantProfile(merchantId: merchant.id.uuidString))
                            }
                    }
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
            }
        }
    }

    // MARK: - Favorite Menu Items

    @ViewBuilder
    private var favoriteMenuItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorite Items")
                .font(.headline)
                .padding(.horizontal, Constants.Layout.horizontalPadding)

            LazyVStack(spacing: 8) {
                ForEach(viewModel.menuItems) { item in
                    FavoriteMenuItemRow(item: item)
                        .onTapGesture {
                            router.push(.menuItemDetail(
                                itemId: item.id.uuidString,
                                merchantId: item.merchantId.uuidString
                            ))
                        }
                }
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
    }
}

// MARK: - Favorite Merchant Card

private struct FavoriteMerchantCard: View {
    let merchant: Merchant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImageView(url: merchant.heroImageURL, cornerRadius: 10)
                .frame(width: 140, height: 100)

            VStack(alignment: .leading, spacing: 2) {
                Text(merchant.name)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)

                    Text(merchant.formattedRating)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 140)
    }
}

// MARK: - Favorite Menu Item Row

private struct FavoriteMenuItemRow: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 12) {
            AsyncImageView(url: item.imageURL, cornerRadius: 8)
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)

                Text(item.formattedPrice)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .environment(\.services, .mock)
            .environment(Router())
    }
}
