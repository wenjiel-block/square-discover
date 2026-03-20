import SwiftUI

struct MenuItemDetailView: View {
    let itemId: String
    let merchantId: String

    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = MenuItemDetailViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoadingView(message: "Loading item...")
                } else if let error = viewModel.error {
                    ErrorView(
                        message: "Could not load item",
                        description: error.localizedDescription,
                        retryAction: {
                            Task {
                                await viewModel.loadItem(id: itemId, using: services.menuService)
                            }
                        }
                    )
                } else if let item = viewModel.menuItem {
                    itemDetailContent(item)
                }
            }
            .navigationTitle("Item Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .task {
                if viewModel.menuItem == nil {
                    await viewModel.loadItem(id: itemId, using: services.menuService)
                }
            }
        }
    }

    // MARK: - Detail Content

    private func itemDetailContent(_ item: MenuItem) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image
                AsyncImageView(url: item.imageURL, cornerRadius: 0)
                    .frame(height: 240)
                    .frame(maxWidth: .infinity)
                    .clipped()

                VStack(alignment: .leading, spacing: 16) {
                    // Name and price
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.title2.weight(.bold))

                            Text(item.formattedPrice)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Color.brandPrimary)
                        }

                        Spacer()

                        if item.isPopular {
                            Text("Popular")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.brandAccent, in: Capsule())
                        }
                    }

                    // Description
                    if !item.description.isEmpty {
                        Text(item.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    // Dietary tags
                    if !item.dietaryTags.isEmpty {
                        dietaryTagsSection(item.dietaryTags)
                    }

                    // Customization sections
                    if item.hasCustomizations {
                        customizationsSection(item)
                    }

                    // Quantity stepper
                    quantitySection

                    Spacer()
                        .frame(height: 20)
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
                .padding(.top, 20)
            }
        }
        .safeAreaInset(edge: .bottom) {
            addToCartButton
        }
    }

    // MARK: - Dietary Tags

    private func dietaryTagsSection(_ tags: [DietaryTag]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Dietary Info")
                .font(.headline)

            FlowLayout(spacing: 8) {
                ForEach(tags) { tag in
                    Label(tag.displayName, systemImage: tag.systemImage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.surfaceSecondary, in: Capsule())
                }
            }
        }
    }

    // MARK: - Customizations

    private func customizationsSection(_ item: MenuItem) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(item.customizations) { customization in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
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

                        if customization.allowsMultipleSelections {
                            Text("Select up to \(customization.maxSelections)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    ForEach(customization.options) { option in
                        customizationOptionRow(option, customizationId: customization.id, isMultiSelect: customization.allowsMultipleSelections)
                    }
                }
                .padding(.top, 4)
            }
        }
    }

    private func customizationOptionRow(_ option: CustomizationOption, customizationId: UUID, isMultiSelect: Bool) -> some View {
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
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Quantity

    private var quantitySection: some View {
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
        .padding(.top, 8)
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

// MARK: - FlowLayout

/// A simple horizontal flow layout that wraps items to the next line.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            totalWidth = max(totalWidth, currentX - spacing)
        }

        return (
            size: CGSize(width: totalWidth, height: currentY + lineHeight),
            positions: positions
        )
    }
}

#Preview {
    MenuItemDetailView(itemId: UUID().uuidString, merchantId: UUID().uuidString)
        .environment(\.services, .mock)
}
