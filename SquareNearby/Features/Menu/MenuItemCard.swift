import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    // Name and popular badge
                    HStack(spacing: 6) {
                        Text(item.name)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        if item.isPopular {
                            popularBadge
                        }
                    }

                    // Description
                    if !item.description.isEmpty {
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    // Price
                    Text(item.formattedPrice)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                        .padding(.top, 2)

                    // Dietary tags
                    if !item.dietaryTags.isEmpty {
                        dietaryTagsRow
                            .padding(.top, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Image
                AsyncImageView(url: item.imageURL, cornerRadius: 8)
                    .frame(width: 80, height: 80)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), \(item.formattedPrice)")
    }

    // MARK: - Subviews

    private var popularBadge: some View {
        Text("Popular")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.brandAccent, in: Capsule())
    }

    private var dietaryTagsRow: some View {
        HStack(spacing: 4) {
            ForEach(item.dietaryTags.prefix(3)) { tag in
                Image(systemName: tag.systemImage)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(tag.displayName)
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        MenuItemCard(
            item: MenuItem(
                merchantId: UUID(),
                name: "Spicy Tuna Roll",
                description: "Fresh tuna with spicy mayo, cucumber, and avocado",
                priceCents: 1495,
                isPopular: true,
                dietaryTags: [.spicy, .glutenFree]
            ),
            onTap: {}
        )
        Divider()
        MenuItemCard(
            item: MenuItem(
                merchantId: UUID(),
                name: "Garden Salad",
                description: "Mixed greens with house vinaigrette",
                priceCents: 895,
                dietaryTags: [.vegan, .glutenFree]
            ),
            onTap: {}
        )
    }
}
