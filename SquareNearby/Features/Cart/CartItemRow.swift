import SwiftUI

struct CartItemRow: View {
    let item: CartItem
    let onUpdateQuantity: (Int) -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Item details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.menuItem.name)
                    .font(.body.weight(.semibold))
                    .lineLimit(2)

                // Customizations summary
                if !item.selectedCustomizations.isEmpty {
                    Text(customizationsSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                // Unit price if quantity > 1
                if item.quantity > 1 {
                    Text("\(item.formattedUnitPrice) each")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Price and quantity
            VStack(alignment: .trailing, spacing: 8) {
                Text(item.formattedTotalPrice)
                    .font(.body.weight(.medium))

                quantityStepper
            }
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.vertical, 12)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }

    // MARK: - Quantity Stepper

    private var quantityStepper: some View {
        HStack(spacing: 12) {
            Button {
                let newQuantity = item.quantity - 1
                if newQuantity <= 0 {
                    onDelete()
                } else {
                    onUpdateQuantity(newQuantity)
                }
            } label: {
                Image(systemName: item.quantity == 1 ? "trash.circle.fill" : "minus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(item.quantity == 1 ? Color.brandAccent : Color.brandPrimary)
            }

            Text("\(item.quantity)")
                .font(.subheadline.weight(.semibold))
                .frame(minWidth: 20)

            Button {
                onUpdateQuantity(item.quantity + 1)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.brandPrimary)
            }
        }
    }

    // MARK: - Helpers

    private var customizationsSummary: String {
        item.selectedCustomizations.map(\.name).joined(separator: ", ")
    }
}

#Preview {
    List {
        CartItemRow(
            item: CartItem(
                menuItem: MenuItem(
                    merchantId: UUID(),
                    name: "Spicy Tuna Roll",
                    description: "Fresh tuna with spicy mayo",
                    priceCents: 1495
                ),
                quantity: 2,
                selectedCustomizations: [
                    CustomizationOption(name: "Extra Spicy"),
                    CustomizationOption(name: "No Wasabi")
                ]
            ),
            onUpdateQuantity: { _ in },
            onDelete: {}
        )

        CartItemRow(
            item: CartItem(
                menuItem: MenuItem(
                    merchantId: UUID(),
                    name: "Miso Soup",
                    priceCents: 495
                ),
                quantity: 1
            ),
            onUpdateQuantity: { _ in },
            onDelete: {}
        )
    }
    .listStyle(.plain)
}
