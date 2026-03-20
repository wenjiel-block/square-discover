import Foundation

@Observable
final class CreatePostViewModel {
    var selectedImage: Data?
    var caption: String = ""
    var selectedMerchant: Merchant?
    var selectedMenuItem: MenuItem?
    var isPosting: Bool = false
    var error: String?

    @MainActor
    func createPost(using contentService: any ContentServiceProtocol) async {
        guard let selectedMerchant else {
            error = "Please tag a merchant."
            return
        }
        guard selectedImage != nil else {
            error = "Please select an image."
            return
        }

        isPosting = true
        error = nil

        do {
            // Build a MediaContent from the selected image.
            // In a real implementation, the image data would be uploaded first
            // via MediaServiceProtocol and the resulting URL used here.
            let placeholderURL = URL(string: "https://api.squarenearby.com/uploads/placeholder.jpg")!
            let media = MediaContent(
                type: .image,
                url: placeholderURL,
                aspectRatio: 1.0
            )

            _ = try await contentService.createPost(
                merchantId: selectedMerchant.id,
                menuItemId: selectedMenuItem?.id,
                media: [media],
                caption: caption
            )
        } catch {
            self.error = error.localizedDescription
        }

        isPosting = false
    }
}
