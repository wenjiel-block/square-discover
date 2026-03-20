import SwiftUI

struct CartView: View {
    @Environment(\.services) private var services
    @Environment(Router.self) private var router

    @State private var viewModel: CartViewModel?

    var body: some View {
        Group {
            if let viewModel, !viewModel.isEmpty {
                cartContent(viewModel)
            } else {
                emptyState
            }
        }
        .navigationTitle("Your Cart")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let viewModel, !viewModel.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        viewModel.clearCart()
                    }
                    .foregroundStyle(Color.brandAccent)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = CartViewModel(cartManager: services.cartManager)
            }
        }
    }

    // MARK: - Cart Content

    private func cartContent(_ vm: CartViewModel) -> some View {
        VStack(spacing: 0) {
            // Item list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(vm.items) { item in
                        CartItemRow(
                            item: item,
                            onUpdateQuantity: { quantity in
                                vm.updateQuantity(for: item, quantity: quantity)
                            },
                            onDelete: {
                                vm.removeItem(item)
                            }
                        )

                        Divider()
                            .padding(.leading, Constants.Layout.horizontalPadding)
                    }
                }
            }

            Divider()

            // Summary and checkout
            VStack(spacing: 16) {
                CartSummaryView(
                    subtotal: vm.formattedSubtotal,
                    tax: vm.formattedTax,
                    total: vm.formattedTotal
                )

                Button {
                    router.push(.checkout)
                } label: {
                    Text("Proceed to Checkout")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(Constants.Layout.horizontalPadding)
            .background(.ultraThinMaterial)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 24) {
            EmptyStateView(
                systemImage: "cart",
                title: "Your Cart is Empty",
                subtitle: "Browse nearby merchants and add items to get started."
            )

            PillButton(title: "Browse Merchants", systemImage: "magnifyingglass") {
                router.popToRoot()
            }
        }
    }
}

#Preview("With Items") {
    let container = ServiceContainer.mock
    // Pre-populate cart for preview
    container.cartManager.addItem(
        MenuItem(
            merchantId: UUID(),
            name: "Spicy Tuna Roll",
            priceCents: 1495
        ),
        quantity: 2
    )
    container.cartManager.addItem(
        MenuItem(
            merchantId: container.cartManager.cart.merchantId ?? UUID(),
            name: "Miso Soup",
            priceCents: 495
        )
    )

    return NavigationStack {
        CartView()
            .environment(\.services, container)
            .environment(Router())
    }
}

#Preview("Empty") {
    NavigationStack {
        CartView()
            .environment(\.services, .mock)
            .environment(Router())
    }
}
