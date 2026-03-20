import SwiftUI

struct PriceLabel: View {
    let priceCents: Int
    var font: Font = .body

    var body: some View {
        Text(formattedPrice)
            .font(font)
    }

    private var formattedPrice: String {
        let dollars = Double(priceCents) / 100.0
        return String(format: "$%.2f", dollars)
    }
}

#Preview {
    VStack(spacing: 12) {
        PriceLabel(priceCents: 1299)
        PriceLabel(priceCents: 1299, font: .title)
        PriceLabel(priceCents: 999, font: .caption)
        PriceLabel(priceCents: 0)
    }
}
