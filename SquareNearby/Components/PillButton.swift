import SwiftUI

struct PillButton: View {
    let title: String
    var systemImage: String?
    var foregroundColor: Color = .white
    var backgroundColor: Color = .brandPrimary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.subheadline.weight(.semibold))
                }

                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(backgroundColor, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        PillButton(title: "Follow", systemImage: "plus") {}
        PillButton(title: "Order Now", backgroundColor: .brandAccent) {}
        PillButton(
            title: "Save",
            systemImage: "bookmark",
            foregroundColor: .primary,
            backgroundColor: Color.surfaceSecondary
        ) {}
    }
}
