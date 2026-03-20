import SwiftUI

enum ToastType {
    case success
    case error

    var systemImage: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        }
    }
}

struct ToastView: View {
    let message: String
    let type: ToastType

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: type.systemImage)
                .foregroundStyle(type.tintColor)

            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: ToastType
    var duration: TimeInterval = 2.5

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    ToastView(message: message, type: type)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                                    isPresented = false
                                }
                            }
                        }
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: Constants.Animation.fast), value: isPresented)
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        type: ToastType,
        duration: TimeInterval = 2.5
    ) -> some View {
        modifier(
            ToastModifier(
                isPresented: isPresented,
                message: message,
                type: type,
                duration: duration
            )
        )
    }
}

#Preview {
    @Previewable @State var showToast = true

    VStack {
        Button("Show Toast") {
            showToast = true
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .toast(isPresented: $showToast, message: "Order placed successfully!", type: .success)
}
