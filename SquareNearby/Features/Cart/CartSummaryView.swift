import SwiftUI

struct CartSummaryView: View {
    let subtotal: String
    let tax: String
    let total: String

    var body: some View {
        VStack(spacing: 8) {
            summaryRow(label: "Subtotal", value: subtotal)
            summaryRow(label: "Tax", value: tax)

            Divider()

            summaryRow(label: "Total", value: total, isBold: true)
        }
    }

    private func summaryRow(label: String, value: String, isBold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(isBold ? .body.weight(.bold) : .subheadline)
                .foregroundStyle(isBold ? .primary : .secondary)

            Spacer()

            Text(value)
                .font(isBold ? .body.weight(.bold) : .subheadline.weight(.medium))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    CartSummaryView(
        subtotal: "$34.85",
        tax: "$3.05",
        total: "$37.90"
    )
    .padding()
}
