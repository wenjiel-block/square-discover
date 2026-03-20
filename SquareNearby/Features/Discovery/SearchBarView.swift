import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search restaurants, cuisines..."
    var onCommit: (() -> Void)?

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.body)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .font(.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit {
                    onCommit?()
                }

            if !text.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                        text = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var filledText = "Sushi"

    VStack(spacing: 16) {
        SearchBarView(text: $text)
        SearchBarView(text: $filledText)
    }
    .padding()
}
