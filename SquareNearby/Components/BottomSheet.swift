import SwiftUI

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent

    @State private var dragOffset: CGFloat = 0
    private let dismissThreshold: CGFloat = 120

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: Constants.Animation.standard)) {
                                isPresented = false
                            }
                        }
                        .transition(.opacity)
                }
            }
            .overlay(alignment: .bottom) {
                if isPresented {
                    sheetView
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut(duration: Constants.Animation.standard), value: isPresented)
    }

    private var sheetView: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)

            sheetContent()
        }
        .frame(maxWidth: .infinity)
        .background(Color.surfacePrimary)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 20,
                topTrailingRadius: 20
            )
        )
        .offset(y: max(0, dragOffset))
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.height
                }
                .onEnded { value in
                    if value.translation.height > dismissThreshold {
                        withAnimation(.easeInOut(duration: Constants.Animation.standard)) {
                            isPresented = false
                        }
                    }
                    withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                        dragOffset = 0
                    }
                }
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheetModifier(isPresented: isPresented, sheetContent: content))
    }
}

#Preview {
    @Previewable @State var showSheet = true

    VStack {
        Button("Show Sheet") {
            showSheet = true
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .bottomSheet(isPresented: $showSheet) {
        VStack(spacing: 16) {
            Text("Bottom Sheet")
                .font(.headline)
            Text("Swipe down or tap outside to dismiss.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .padding(.bottom, 32)
    }
}
