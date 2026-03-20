import SwiftUI

struct RatingView: View {
    let rating: Double
    var starSize: CGFloat = 14
    var starColor: Color = .yellow

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                starImage(for: index)
                    .font(.system(size: starSize))
                    .foregroundStyle(starColor)
            }
        }
    }

    private func starImage(for index: Int) -> Image {
        let threshold = Double(index)
        if rating >= threshold + 1.0 {
            return Image(systemName: "star.fill")
        } else if rating >= threshold + 0.5 {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        RatingView(rating: 5.0)
        RatingView(rating: 4.5)
        RatingView(rating: 3.7)
        RatingView(rating: 2.0)
        RatingView(rating: 0.0)
        RatingView(rating: 4.3, starSize: 24, starColor: .orange)
    }
}
