import SwiftUI

struct MerchantHeaderView: View {
    let merchant: Merchant

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            heroImage

            VStack(alignment: .leading, spacing: 8) {
                nameRow
                ratingRow
                cuisineChips
                statusRow
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        AsyncImageView(
            url: merchant.heroImageURL,
            cornerRadius: 0,
            contentMode: .fill
        )
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    // MARK: - Name

    private var nameRow: some View {
        HStack(spacing: 6) {
            Text(merchant.name)
                .font(.title2.weight(.bold))

            if merchant.isVerified {
                VerifiedBadge(size: 18)
            }
        }
    }

    // MARK: - Rating

    private var ratingRow: some View {
        HStack(spacing: 6) {
            RatingView(rating: merchant.rating, starSize: 16)

            Text(merchant.formattedRating)
                .font(.subheadline.weight(.semibold))

            Text("(\(merchant.formattedReviewCount) reviews)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Cuisine Chips

    private var cuisineChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(merchant.cuisineTypes) { cuisine in
                    Text("\(cuisine.emoji) \(cuisine.displayName)")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.surfaceSecondary, in: Capsule())
                }
            }
        }
    }

    // MARK: - Status Row

    private var statusRow: some View {
        HStack(spacing: 12) {
            openClosedBadge

            Text(merchant.priceLevel.display)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            if let pickupTime = merchant.formattedPickupTime {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(pickupTime)
                        .font(.subheadline)
                }
                .foregroundStyle(.secondary)
            }

            if let distance = merchant.location.formattedDistance {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(distance)
                        .font(.subheadline)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 2)
    }

    private var openClosedBadge: some View {
        Text(merchant.isCurrentlyOpen ? "Open Now" : "Closed")
            .font(.caption.weight(.semibold))
            .foregroundStyle(merchant.isCurrentlyOpen ? .green : .red)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                (merchant.isCurrentlyOpen ? Color.green : Color.red).opacity(0.12),
                in: Capsule()
            )
    }
}

#Preview {
    ScrollView {
        MerchantHeaderView(
            merchant: Merchant(
                name: "Tartine Bakery",
                description: "Famous San Francisco bakery",
                cuisineTypes: [.bakery, .french],
                location: Location(latitude: 37.7614, longitude: -122.4241, distanceMiles: 0.3),
                address: "600 Guerrero St, San Francisco, CA 94110",
                phoneNumber: "(415) 487-2600",
                rating: 4.7,
                reviewCount: 1250,
                priceLevel: .moderate,
                isVerified: true,
                isCurrentlyOpen: true,
                estimatedPickupTime: 15
            )
        )
    }
}
