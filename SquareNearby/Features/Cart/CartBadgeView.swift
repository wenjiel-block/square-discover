import SwiftUI

struct CartBadgeView: View {
    let itemCount: Int

    var body: some View {
        if itemCount > 0 {
            Text(itemCount > 99 ? "99+" : "\(itemCount)")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, itemCount > 9 ? 5 : 6)
                .padding(.vertical, 2)
                .background(Color.brandAccent, in: Capsule())
                .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Badge on a cart icon
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart.fill")
                .font(.title2)
                .foregroundStyle(Color.brandPrimary)

            CartBadgeView(itemCount: 3)
                .offset(x: 10, y: -8)
        }

        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart.fill")
                .font(.title2)
                .foregroundStyle(Color.brandPrimary)

            CartBadgeView(itemCount: 12)
                .offset(x: 12, y: -8)
        }

        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart.fill")
                .font(.title2)
                .foregroundStyle(Color.brandPrimary)

            CartBadgeView(itemCount: 0)
                .offset(x: 10, y: -8)
        }
    }
    .padding()
}
