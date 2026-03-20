import SwiftUI
import PhotosUI

struct MediaPickerView: View {
    var onSelect: (Data) -> Void
    @State private var selectedItem: PhotosPickerItem?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .any(of: [.images, .videos]),
            photoLibrary: .shared()
        ) {
            Label("Select from Library", systemImage: "photo.on.rectangle")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
        .onChange(of: selectedItem) { _, newValue in
            guard let newValue else { return }
            Task {
                if let data = try? await newValue.loadTransferable(type: Data.self) {
                    onSelect(data)
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    MediaPickerView { _ in }
}
