import SwiftUI

struct AddToCartSheet: View {
    let menuItem: MenuItem

    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: MenuItemDetailViewModel

    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        self._viewModel = State(initialValue: MenuItemDetailViewModel(menuItem: menuItem))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Item header
                    itemHeader

                    // Customization sections
                    if menuItem.hasCustomizations {
                        customizationsSection
                    }

                    // Quantity selector
                    quantitySelector

                    Spacer()
                        .frame(height: 20)
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
                .padding(.top, 16)
            }
            .navigationTitle(menuItem.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                addToCartButton
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Item Header

    private var itemHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name)
                    .font(.headline)

                if !menuItem.description.isEmpty {
                    Text(menuItem.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(menuItem.formattedPrice)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.brandPrimary)
                    .padding(.top, 2)
            }

            Spacer()

            AsyncImageView(url: menuItem.imageURL, cornerRadius: 8)
                .frame(width: 72, height: 72)
        }
    }

    // MARK: - Customizations

    private var customizationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(menuItem.customizations) { customization in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(customization.name)
                            .font(.headline)

                        if customization.isRequired {
                            Text("Required")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.brandAccent, in: Capsule())
                        }
                    }

                    if customization.allowsMultipleSelections {
                        Text("Select up to \(customization.maxSelections)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    ForEach(customization.options) { option in
                        optionRow(
                            option: option,
                            customizationId: customization.id,
                            isMultiSelect: customization.allowsMultipleSelections
                        )
                    }
                }

                Divider()
            }
        }
    }

    private func optionRow(option: CustomizationOption, customizationId: UUID, isMultiSelect: Bool) -> some View {
        let isSelected = viewModel.isOptionSelected(option.id, in: customizationId)

        return Button {
            viewModel.toggleOption(option.id, in: customizationId)
        } label: {
            HStack {
                Image(systemName: isMultiSelect
                    ? (isSelected ? "checkmark.square.fill" : "square")
                    : (isSelected ? "largecircle.fill.circle" : "circle")
                )
                .foregroundStyle(isSelected ? Color.brandPrimary : .secondary)
                .font(.body)

                Text(option.name)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                if let price = option.formattedAdditionalPrice {
                    Text(price)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Quantity Selector

    private var quantitySelector: some View {
        HStack {
            Text("Quantity")
                .font(.headline)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    viewModel.decrementQuantity()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.quantity > 1 ? Color.brandPrimary : .secondary)
                }
                .disabled(viewModel.quantity <= 1)

                Text("\(viewModel.quantity)")
                    .font(.title3.weight(.semibold))
                    .frame(minWidth: 30)

                Button {
                    viewModel.incrementQuantity()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.brandPrimary)
                }
            }
        }
    }

    // MARK: - Add to Cart

    private var addToCartButton: some View {
        Button {
            viewModel.addToCart(cartManager: services.cartManager)
            dismiss()
        } label: {
            HStack {
                Text("Add to Cart")
                    .font(.body.weight(.bold))

                Spacer()

                Text(viewModel.formattedTotal)
                    .font(.body.weight(.bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                viewModel.isValid ? Color.brandPrimary : Color.gray,
                in: RoundedRectangle(cornerRadius: 14)
            )
        }
        .disabled(!viewModel.isValid)
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    AddToCartSheet(
        menuItem: MenuItem(
            merchantId: UUID(),
            name: "Spicy Tuna Roll",
            description: "Fresh tuna with spicy mayo, cucumber, and avocado",
            priceCents: 1495,
            isPopular: true,
            dietaryTags: [.spicy],
            customizations: [
                MenuItemCustomization(
                    name: "Size",
                    options: [
                        CustomizationOption(name: "Regular"),
                        CustomizationOption(name: "Large", additionalPriceCents: 300),
                    ],
                    isRequired: true,
                    maxSelections: 1
                )
            ]
        )
    )
    .environment(\.services, .mock)
}
