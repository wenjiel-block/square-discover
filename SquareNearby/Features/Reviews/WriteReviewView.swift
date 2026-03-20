import SwiftUI
import PhotosUI

struct WriteReviewView: View {
    let merchantId: String
    @State private var viewModel = WriteReviewViewModel()
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss

    private var merchantUUID: UUID? {
        UUID(uuidString: merchantId)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Star Rating
                VStack(spacing: 8) {
                    Text("How was your experience?")
                        .font(.headline)

                    StarRatingView(rating: $viewModel.rating)
                }
                .padding(.top, 16)

                // Review Text
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Review")
                        .font(.subheadline.weight(.medium))

                    TextField(
                        "Tell others about your experience...",
                        text: $viewModel.reviewText,
                        axis: .vertical
                    )
                    .lineLimit(4...12)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 10))

                    Text("\(viewModel.reviewText.count)/\(Constants.Content.maxReviewLength)")
                        .font(.caption2)
                        .foregroundStyle(
                            viewModel.reviewText.count > Constants.Content.maxReviewLength ? .red : .secondary
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)

                // Photo Attachment
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Photos")
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, Constants.Layout.horizontalPadding)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            // Photo picker button
                            PhotosPicker(
                                selection: $selectedPhotos,
                                maxSelectionCount: Constants.Content.maxImagesPerPost,
                                matching: .images
                            ) {
                                VStack {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundStyle(Color.brandPrimary)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 10))
                            }

                            // Selected media thumbnails
                            ForEach(viewModel.selectedMedia.indices, id: \.self) { index in
                                if let uiImage = UIImage(data: viewModel.selectedMedia[index]) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                viewModel.selectedMedia.remove(at: index)
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.caption)
                                                    .foregroundStyle(.white)
                                                    .background(.black.opacity(0.5), in: Circle())
                                            }
                                            .padding(4)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                    }
                }

                // Error
                if let error = viewModel.error {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                }

                // Submit Button
                Button {
                    Task {
                        if let uuid = merchantUUID {
                            await viewModel.submitReview(
                                merchantId: uuid,
                                using: services.reviewService
                            )
                            if viewModel.error == nil {
                                dismiss()
                            }
                        }
                    }
                } label: {
                    Group {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Submit Review")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 12))
                }
                .disabled(viewModel.isSubmitting)
                .padding(.horizontal, Constants.Layout.horizontalPadding)
            }
        }
        .navigationTitle("Write a Review")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedPhotos) { _, items in
            Task {
                var mediaData: [Data] = []
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        mediaData.append(data)
                    }
                }
                viewModel.selectedMedia = mediaData
            }
        }
    }
}

#Preview {
    NavigationStack {
        WriteReviewView(merchantId: UUID().uuidString)
            .environment(\.services, .mock)
    }
}
