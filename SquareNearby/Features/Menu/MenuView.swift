import SwiftUI

struct MenuView: View {
    let merchantId: String

    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    @State private var viewModel = MenuViewModel()
    @State private var selectedItem: MenuItem?

    var body: some View {
        ZStack(alignment: .bottom) {
            mainContent
            cartFloatingButton
        }
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMenu(merchantId: merchantId, using: services.menuService)
        }
        .sheet(item: $selectedItem) { item in
            AddToCartSheet(menuItem: item)
        }
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isLoading {
            LoadingView(message: "Loading menu...")
        } else if let error = viewModel.error {
            ErrorView(
                message: "Could not load menu",
                description: error.localizedDescription,
                retryAction: {
                    Task {
                        await viewModel.loadMenu(merchantId: merchantId, using: services.menuService)
                    }
                }
            )
        } else if viewModel.categories.isEmpty {
            EmptyStateView(
                systemImage: "menucard",
                title: "No Menu Available",
                subtitle: "This merchant hasn't published a menu yet."
            )
        } else {
            menuList
        }
    }

    private var menuList: some View {
        VStack(spacing: 0) {
            // Category tab bar
            MenuCategoryTabBar(
                categories: viewModel.categories,
                selectedCategory: $viewModel.selectedCategory
            )

            Divider()

            // Scrollable menu items grouped by category
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(viewModel.categories) { category in
                            Section {
                                ForEach(category.availableItems) { item in
                                    MenuItemCard(item: item) {
                                        selectedItem = item
                                    }
                                    Divider()
                                        .padding(.leading, Constants.Layout.horizontalPadding)
                                }
                            } header: {
                                sectionHeader(category.name)
                                    .id(category.id)
                            }
                        }

                        // Bottom spacer for floating cart button
                        Spacer()
                            .frame(height: 100)
                    }
                }
                .onChange(of: viewModel.selectedCategory?.id) { _, newId in
                    guard let newId else { return }
                    withAnimation(.easeInOut(duration: Constants.Animation.standard)) {
                        proxy.scrollTo(newId, anchor: .top)
                    }
                }
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3.weight(.bold))
            .foregroundStyle(.primary)
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
    }

    // MARK: - Floating Cart Button

    @ViewBuilder
    private var cartFloatingButton: some View {
        let cartManager = services.cartManager
        if !cartManager.cart.isEmpty {
            Button {
                router.push(.cart)
            } label: {
                HStack {
                    Label("\(cartManager.cart.itemCount) items", systemImage: "cart.fill")
                        .font(.body.weight(.semibold))

                    Spacer()

                    Text(cartManager.cart.formattedTotal)
                        .font(.body.weight(.bold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.bottom, 8)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    NavigationStack {
        MenuView(merchantId: UUID().uuidString)
            .environment(\.services, .mock)
            .environment(Router())
    }
}
