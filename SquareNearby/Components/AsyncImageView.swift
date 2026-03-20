import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    var cornerRadius: CGFloat = 8
    var contentMode: ContentMode = .fill

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                SkeletonView(shape: .roundedRectangle(cornerRadius: cornerRadius))
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            case .failure:
                errorPlaceholder
            @unknown default:
                errorPlaceholder
            }
        }
    }

    private var errorPlaceholder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.surfaceSecondary)
            .overlay {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    VStack {
        AsyncImageView(url: nil)
            .frame(width: 200, height: 150)

        AsyncImageView(
            url: URL(string: "https://example.com/image.jpg"),
            cornerRadius: 16
        )
        .frame(width: 200, height: 150)
    }
}
