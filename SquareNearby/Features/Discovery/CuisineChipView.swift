import SwiftUI

struct CuisineChipView: View {
    let cuisine: Cuisine
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                Text(cuisine.emoji)
                    .font(.caption)

                Text(cuisine.displayName)
                    .font(.caption.weight(.medium))
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(isSelected ? .white : .primary)
            .background(
                isSelected ? Color.brandPrimary : Color.surfaceSecondary,
                in: Capsule()
            )
            .overlay {
                if !isSelected {
                    Capsule()
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 0.5)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel("\(cuisine.displayName) cuisine filter")
    }
}

#Preview {
    HStack(spacing: 8) {
        CuisineChipView(cuisine: .japanese, isSelected: true) {}
        CuisineChipView(cuisine: .italian, isSelected: false) {}
        CuisineChipView(cuisine: .mexican, isSelected: false) {}
        CuisineChipView(cuisine: .coffee, isSelected: true) {}
    }
    .padding()
}
