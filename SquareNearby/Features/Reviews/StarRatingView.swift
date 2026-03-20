import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var starSize: CGFloat = 36
    var starColor: Color = .yellow

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.system(size: starSize))
                    .foregroundStyle(index <= rating ? starColor : .gray.opacity(0.4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                            rating = index
                        }
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating: \(rating) out of 5 stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < 5 { rating += 1 }
            case .decrement:
                if rating > 1 { rating -= 1 }
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    @Previewable @State var rating = 3
    VStack(spacing: 20) {
        StarRatingView(rating: $rating)
        Text("Selected: \(rating) stars")
    }
}
