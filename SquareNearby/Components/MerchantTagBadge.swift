import SwiftUI

struct MerchantTagBadge: View {
    let name: String
    var logoURL: URL?
    var action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 6) {
                if let logoURL {
                    AsyncImage(url: logoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 18, height: 18)
                                .clipShape(Circle())
                        default:
                            Circle()
                                .fill(Color.brandPrimary.opacity(0.2))
                                .frame(width: 18, height: 18)
                        }
                    }
                }

                Text(name)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(Color.primary.opacity(0.1), lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        MerchantTagBadge(name: "Blue Bottle Coffee")
        MerchantTagBadge(
            name: "Tartine Bakery",
            logoURL: URL(string: "https://example.com/logo.jpg")
        )
        MerchantTagBadge(name: "Flour + Water") {
            // action
        }
    }
}
