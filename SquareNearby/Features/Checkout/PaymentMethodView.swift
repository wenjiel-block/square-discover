import SwiftUI

struct PaymentMethodView: View {
    @Binding var selectedMethod: String

    var body: some View {
        VStack(spacing: 10) {
            ForEach(CheckoutViewModel.paymentMethods, id: \.id) { method in
                paymentOption(method)
            }
        }
    }

    // MARK: - Subviews

    private func paymentOption(_ method: (id: String, name: String, icon: String)) -> some View {
        let isSelected = selectedMethod == method.id

        return Button {
            selectedMethod = method.id
        } label: {
            HStack(spacing: 12) {
                Image(systemName: method.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.brandPrimary : .secondary)
                    .frame(width: 28)

                Text(method.name)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color.brandPrimary : .secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius)
                    .stroke(isSelected ? Color.brandPrimary : Color.secondary.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var method = "applePay"

    PaymentMethodView(selectedMethod: $method)
        .padding()
}
