import SwiftUI

struct MerchantListRowView: View {
    let merchant: Merchant

    @Environment(Router.self) private var router

    var body: some View {
        Button {
            router.push(.merchantProfile(merchantId: merchant.id.uuidString))
        } label: {
            HStack(spacing: 12) {
                heroImage
                merchantDetails
            }
            .padding(12)
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
            .shadow(
                color: .black.opacity(0.08),
                radius: Constants.Layout.cardShadowRadius,
                y: 2
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        AsyncImageView(
            url: merchant.heroImageURL,
            cornerRadius: 8,
            contentMode: .fill
        )
        .frame(width: 100, height: 100)
        .clipped()
    }

    // MARK: - Merchant Details

    private var merchantDetails: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Text(merchant.name)
                    .font(.headline)
                    .lineLimit(1)

                if merchant.isVerified {
                    VerifiedBadge(size: 14)
                }
            }

            cuisineAndPriceRow

            ratingRow

            bottomRow
        }
    }

    private var cuisineAndPriceRow: some View {
        HStack(spacing: 6) {
            if let cuisine = merchant.primaryCuisine {
                Text("\(cuisine.emoji) \(cuisine.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("·")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(merchant.priceLevel.display)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }

    private var ratingRow: some View {
        HStack(spacing: 4) {
            RatingView(rating: merchant.rating, starSize: 12)

            Text(merchant.formattedRating)
                .font(.caption.weight(.semibold))

            Text("(\(merchant.formattedReviewCount))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var bottomRow: some View {
        HStack(spacing: 8) {
            if let distance = merchant.location.formattedDistance {
                Label(distance, systemImage: "location.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            openClosedBadge
        }
    }

    private var openClosedBadge: some View {
        Text(merchant.isCurrentlyOpen ? "Open" : "Closed")
            .font(.caption2.weight(.semibold))
            .foregroundStyle(merchant.isCurrentlyOpen ? .green : .red)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                (merchant.isCurrentlyOpen ? Color.green : Color.red).opacity(0.12),
                in: Capsule()
            )
    }
}

#Preview {
    MerchantListRowView(
        merchant: Merchant(
            name: "Tartine Bakery",
            description: "Famous San Francisco bakery",
            cuisineTypes: [.bakery],
            location: Location(latitude: 37.7614, longitude: -122.4241, distanceMiles: 0.3),
            address: "600 Guerrero St, San Francisco, CA 94110",
            rating: 4.7,
            reviewCount: 1250,
            priceLevel: .moderate,
            isVerified: true,
            isCurrentlyOpen: true,
            estimatedPickupTime: 15
        )
    )
    .padding()
    .environment(Router())
}
