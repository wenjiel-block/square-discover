import SwiftUI

struct MerchantInfoSection: View {
    let merchant: Merchant

    @State private var isHoursExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Info")
                .font(.headline)

            addressRow

            if let phone = merchant.phoneNumber {
                phoneRow(phone)
            }

            businessHoursRow
        }
        .padding(16)
        .background(Color.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
    }

    // MARK: - Address

    private var addressRow: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "map.fill")
                .font(.body)
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text("Address")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(merchant.address)
                    .font(.subheadline)
            }

            Spacer()
        }
    }

    // MARK: - Phone

    private func phoneRow(_ phone: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "phone.fill")
                .font(.body)
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text("Phone")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let url = URL(string: "tel:\(phone.filter { $0.isNumber })") {
                    Link(phone, destination: url)
                        .font(.subheadline)
                        .foregroundStyle(Color.brandPrimary)
                } else {
                    Text(phone)
                        .font(.subheadline)
                }
            }

            Spacer()
        }
    }

    // MARK: - Business Hours

    private var businessHoursRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                    isHoursExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.body)
                        .foregroundStyle(Color.brandPrimary)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hours")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let todayHours = merchant.todayHours {
                            Text("Today: \(todayHours.formattedHours)")
                                .font(.subheadline)
                        } else {
                            Text("Hours not available")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Image(systemName: isHoursExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if isHoursExpanded {
                MerchantHoursView(hours: merchant.hours)
                    .padding(.leading, 36)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    MerchantInfoSection(
        merchant: Merchant(
            name: "Tartine Bakery",
            description: "Famous San Francisco bakery",
            cuisineTypes: [.bakery],
            location: Location(latitude: 37.7614, longitude: -122.4241),
            address: "600 Guerrero St, San Francisco, CA 94110",
            phoneNumber: "(415) 487-2600",
            rating: 4.7,
            reviewCount: 1250,
            priceLevel: .moderate,
            hours: [
                BusinessHours(dayOfWeek: 1, openTime: "08:00", closeTime: "17:00"),
                BusinessHours(dayOfWeek: 2, openTime: "07:30", closeTime: "19:00"),
                BusinessHours(dayOfWeek: 3, openTime: "07:30", closeTime: "19:00"),
                BusinessHours(dayOfWeek: 4, openTime: "07:30", closeTime: "19:00"),
                BusinessHours(dayOfWeek: 5, openTime: "07:30", closeTime: "19:00"),
                BusinessHours(dayOfWeek: 6, openTime: "07:30", closeTime: "19:00"),
                BusinessHours(dayOfWeek: 7, openTime: "07:30", closeTime: "18:00"),
            ],
            isCurrentlyOpen: true
        )
    )
    .padding()
}
