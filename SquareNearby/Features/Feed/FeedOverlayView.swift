import SwiftUI

/// Bottom-left text overlay on a feed card showing merchant badge,
/// author info, caption, and an optional tagged menu item.
struct FeedOverlayView: View {
    let item: FeedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Merchant badge
            MerchantTagBadge(
                name: item.merchant.name,
                logoURL: item.merchant.logoURL
            )

            // Author row
            authorRow

            // Caption (2-line limit)
            if !item.caption.isEmpty {
                Text(item.caption)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }

            // Tagged menu item pill
            if let menuItem = item.menuItemTag {
                menuItemPill(menuItem)
            }
        }
        .frame(maxWidth: 260, alignment: .leading)
    }

    // MARK: - Author Row

    private var authorRow: some View {
        HStack(spacing: 8) {
            AvatarView(
                url: item.author.avatarURL,
                initials: item.author.displayName,
                size: 32
            )

            Text("@\(item.author.username)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)

            Text(item.timeAgo)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
    }

    // MARK: - Menu Item Pill

    private func menuItemPill(_ menuItem: MenuItem) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "fork.knife")
                .font(.caption2.weight(.semibold))

            Text(menuItem.name)
                .font(.caption.weight(.medium))
                .lineLimit(1)

            Text(menuItem.formattedPrice)
                .font(.caption.weight(.bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
    }
}
