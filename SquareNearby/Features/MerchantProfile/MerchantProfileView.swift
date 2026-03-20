import SwiftUI

struct MerchantProfileView: View {
    let merchantId: String

    @Environment(ServiceContainer.self) private var services
    @Environment(Router.self) private var router

    @State private var viewModel: MerchantProfileViewModel
    @State private var selectedTab: ProfileTab = .menu

    enum ProfileTab: String, CaseIterable, Identifiable {
        case menu = "Menu"
        case photos = "Photos"
        case reviews = "Reviews"

        var id: String { rawValue }
    }

    init(merchantId: String) {
        self.merchantId = merchantId
        self._viewModel = State(initialValue: MerchantProfileViewModel(merchantId: merchantId))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.merchant == nil {
                LoadingView(message: "Loading merchant...")
            } else if let error = viewModel.error, viewModel.merchant == nil {
                ErrorView(
                    message: "Could not load merchant",
                    description: error.localizedDescription
                ) {
                    Task { await viewModel.load(using: services) }
                }
            } else if let merchant = viewModel.merchant {
                merchantContent(merchant)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                favoriteButton
            }
        }
        .task {
            await viewModel.load(using: services)
        }
    }

    // MARK: - Main Content

    private func merchantContent(_ merchant: Merchant) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                MerchantHeaderView(merchant: merchant)

                tabPicker

                tabContent(merchant)
            }
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        Picker("Section", selection: $selectedTab) {
            ForEach(ProfileTab.allCases) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.vertical, 12)
    }

    // MARK: - Tab Content

    @ViewBuilder
    private func tabContent(_ merchant: Merchant) -> some View {
        switch selectedTab {
        case .menu:
            menuSection(merchant)
        case .photos:
            MerchantMediaGrid(feedItems: viewModel.feedItems)
                .padding(.horizontal, Constants.Layout.horizontalPadding)
        case .reviews:
            MerchantReviewsSection(reviews: viewModel.reviews, merchantId: merchantId)
                .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
    }

    // MARK: - Menu Section

    private func menuSection(_ merchant: Merchant) -> some View {
        VStack(spacing: 16) {
            MerchantInfoSection(merchant: merchant)
                .padding(.horizontal, Constants.Layout.horizontalPadding)

            Button {
                router.push(.merchantMenu(merchantId: merchantId))
            } label: {
                HStack {
                    Label("View Full Menu", systemImage: "menucard")
                        .font(.headline)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(Color.brandPrimary)
                .padding(16)
                .background(Color.brandPrimary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, Constants.Layout.horizontalPadding)

            MerchantHoursView(hours: merchant.hours)
                .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
        .padding(.bottom, Constants.Layout.sectionSpacing)
    }

    // MARK: - Favorite Button

    private var favoriteButton: some View {
        Button {
            Task { await viewModel.toggleFavorite(using: services) }
        } label: {
            Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(viewModel.isFavorited ? Color.brandAccent : .primary)
                .symbolEffect(.bounce, value: viewModel.isFavorited)
        }
    }
}

#Preview {
    NavigationStack {
        MerchantProfileView(merchantId: UUID().uuidString)
    }
    .environment(ServiceContainer.mock)
    .environment(Router())
}
