import SwiftUI

struct VerifiedBadge: View {
    var size: CGFloat = 16

    var body: some View {
        Image(systemName: "checkmark.seal.fill")
            .font(.system(size: size))
            .foregroundStyle(.white, .blue)
            .accessibilityLabel("Verified")
    }
}

#Preview {
    HStack(spacing: 4) {
        Text("Blue Bottle Coffee")
            .font(.headline)
        VerifiedBadge()
    }
}
