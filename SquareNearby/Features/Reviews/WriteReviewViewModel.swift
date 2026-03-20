import Foundation

@Observable
final class WriteReviewViewModel {
    var rating: Int = 0
    var reviewText: String = ""
    var selectedMedia: [Data] = []
    var isSubmitting: Bool = false
    var error: String?

    @MainActor
    func submitReview(merchantId: UUID, using reviewService: any ReviewServiceProtocol) async {
        guard rating >= 1 && rating <= 5 else {
            error = "Please select a star rating."
            return
        }
        guard !reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            error = "Please write a review."
            return
        }

        isSubmitting = true
        error = nil

        do {
            // Convert selected media data to MediaContent placeholders.
            // In a real implementation, each Data would be uploaded via MediaServiceProtocol first.
            var mediaContent: [MediaContent] = []
            for _ in selectedMedia {
                let placeholderURL = URL(string: "https://api.squarenearby.com/uploads/review-\(UUID().uuidString).jpg")!
                mediaContent.append(
                    MediaContent(type: .image, url: placeholderURL, aspectRatio: 1.0)
                )
            }

            _ = try await reviewService.createReview(
                merchantId: merchantId,
                rating: rating,
                text: reviewText,
                media: mediaContent.isEmpty ? nil : mediaContent,
                menuItemIds: nil
            )
        } catch {
            self.error = error.localizedDescription
        }

        isSubmitting = false
    }
}
