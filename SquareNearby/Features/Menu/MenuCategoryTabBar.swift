import SwiftUI

struct MenuCategoryTabBar: View {
    let categories: [MenuCategory]
    @Binding var selectedCategory: MenuCategory?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        categoryPill(category)
                            .id(category.id)
                    }
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
                .padding(.vertical, 8)
            }
            .onChange(of: selectedCategory?.id) { _, newId in
                guard let newId else { return }
                withAnimation(.easeInOut(duration: Constants.Animation.fast)) {
                    proxy.scrollTo(newId, anchor: .center)
                }
            }
        }
    }

    // MARK: - Subviews

    private func categoryPill(_ category: MenuCategory) -> some View {
        let isSelected = selectedCategory?.id == category.id

        return Button {
            selectedCategory = category
        } label: {
            Text(category.name)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.brandPrimary : Color.surfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var selected: MenuCategory? = nil

    MenuCategoryTabBar(
        categories: [
            MenuCategory(name: "Popular", sortOrder: 0),
            MenuCategory(name: "Appetizers", sortOrder: 1),
            MenuCategory(name: "Entrees", sortOrder: 2),
            MenuCategory(name: "Desserts", sortOrder: 3),
            MenuCategory(name: "Drinks", sortOrder: 4),
        ],
        selectedCategory: $selected
    )
}
