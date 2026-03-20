import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @State private var viewModel = CreatePostViewModel()
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss
    @State private var showMediaPicker = false
    @State private var showCamera = false
    @State private var showMerchantSearch = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Media Preview
                    mediaPreviewSection

                    // Media Source Buttons
                    HStack(spacing: 16) {
                        Button {
                            showCamera = true
                        } label: {
                            Label("Camera", systemImage: "camera.fill")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 10))
                        }

                        Button {
                            showMediaPicker = true
                        } label: {
                            Label("Library", systemImage: "photo.on.rectangle")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, Constants.Layout.horizontalPadding)

                    // Post Editor
                    PostEditorView(
                        caption: $viewModel.caption,
                        selectedMerchant: $viewModel.selectedMerchant,
                        selectedMenuItem: $viewModel.selectedMenuItem,
                        onTagMerchant: { showMerchantSearch = true }
                    )

                    // Error
                    if let error = viewModel.error {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal, Constants.Layout.horizontalPadding)
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await viewModel.createPost(using: services.contentService)
                            if viewModel.error == nil {
                                dismiss()
                            }
                        }
                    } label: {
                        if viewModel.isPosting {
                            ProgressView()
                        } else {
                            Text("Post")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(viewModel.isPosting)
                }
            }
            .sheet(isPresented: $showMediaPicker) {
                MediaPickerView { imageData in
                    viewModel.selectedImage = imageData
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView { imageData in
                    viewModel.selectedImage = imageData
                }
            }
            .sheet(isPresented: $showMerchantSearch) {
                NavigationStack {
                    MerchantTagSearch { merchant in
                        viewModel.selectedMerchant = merchant
                        showMerchantSearch = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var mediaPreviewSection: some View {
        if let imageData = viewModel.selectedImage,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius))
                .padding(.horizontal, Constants.Layout.horizontalPadding)
        } else {
            RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius)
                .fill(Color.surfaceSecondary)
                .frame(height: 200)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.badge.plus")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                        Text("Add a photo or video")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
    }
}

#Preview {
    CreatePostView()
        .environment(\.services, .mock)
}
