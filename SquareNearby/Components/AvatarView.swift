import SwiftUI

struct AvatarView: View {
    let url: URL?
    var initials: String = ""
    var size: CGFloat = 40

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .empty:
                fallbackView
            case .failure:
                fallbackView
            @unknown default:
                fallbackView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var fallbackView: some View {
        Circle()
            .fill(Color.brandPrimary.opacity(0.2))
            .overlay {
                Text(displayInitials)
                    .font(.system(size: size * 0.36, weight: .semibold))
                    .foregroundStyle(Color.brandPrimary)
            }
    }

    private var displayInitials: String {
        guard !initials.isEmpty else { return "?" }
        let components = initials.split(separator: " ")
        let result = components.prefix(2).compactMap { $0.first }.map(String.init).joined()
        return result.uppercased()
    }
}

#Preview {
    HStack(spacing: 16) {
        AvatarView(url: nil, initials: "John Doe", size: 48)
        AvatarView(url: nil, initials: "A", size: 48)
        AvatarView(url: URL(string: "https://example.com/avatar.jpg"), size: 48)
        AvatarView(url: nil, size: 32)
    }
}
