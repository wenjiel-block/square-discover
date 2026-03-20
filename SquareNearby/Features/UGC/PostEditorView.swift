import SwiftUI

struct PostEditorView: View {
    @Binding var caption: String
    @Binding var selectedMerchant: Merchant?
    @Binding var selectedMenuItem: MenuItem?
    var onTagMerchant: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Caption
            VStack(alignment: .leading, spacing: 8) {
                Text("Caption")
                    .font(.subheadline.weight(.medium))

                TextField("Write a caption...", text: $caption, axis: .vertical)
                    .lineLimit(3...8)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 10))

                Text("\(caption.count)/\(Constants.Content.maxCaptionLength)")
                    .font(.caption2)
                    .foregroundStyle(
                        caption.count > Constants.Content.maxCaptionLength ? .red : .secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            // Merchant Tag
            VStack(alignment: .leading, spacing: 8) {
                Text("Tag Merchant")
                    .font(.subheadline.weight(.medium))

                if let merchant = selectedMerchant {
                    HStack {
                        MerchantTagBadge(
                            name: merchant.name,
                            logoURL: merchant.logoURL
                        )

                        Button {
                            selectedMerchant = nil
                            selectedMenuItem = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Button(action: onTagMerchant) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add merchant tag")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.brandPrimary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }

            // Menu Item Tag
            if selectedMerchant != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tag Menu Item (Optional)")
                        .font(.subheadline.weight(.medium))

                    if let menuItem = selectedMenuItem {
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: "fork.knife")
                                    .font(.caption)

                                Text(menuItem.name)
                                    .font(.caption.weight(.medium))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())

                            Button {
                                selectedMenuItem = nil
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Text("Search and tag a menu item after posting.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
    }
}

#Preview {
    PostEditorView(
        caption: .constant("Amazing tacos!"),
        selectedMerchant: .constant(nil),
        selectedMenuItem: .constant(nil),
        onTagMerchant: {}
    )
}
