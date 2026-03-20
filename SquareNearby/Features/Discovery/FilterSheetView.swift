import SwiftUI

struct FilterSheetView: View {
    @Bindable var viewModel: DiscoveryViewModel
    var onApply: () -> Void

    @State private var searchRadius: Double = Constants.Map.defaultSearchRadiusMiles

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header

            Divider()

            cuisineSection

            Divider()

            sortSection

            Divider()

            distanceSection

            applyButton
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.bottom, 32)
        .onAppear {
            searchRadius = Constants.Map.defaultSearchRadiusMiles
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Filters")
                .font(.title2.weight(.bold))

            Spacer()

            Button("Clear All") {
                viewModel.clearFilters()
                searchRadius = Constants.Map.defaultSearchRadiusMiles
            }
            .font(.subheadline)
            .foregroundStyle(Color.brandAccent)
        }
    }

    // MARK: - Cuisine Section

    private var cuisineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cuisine")
                .font(.headline)

            cuisineGrid
        }
    }

    private var cuisineGrid: some View {
        let columns = [GridItem(.adaptive(minimum: 100), spacing: 8)]
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Cuisine.allCases) { cuisine in
                CuisineChipView(
                    cuisine: cuisine,
                    isSelected: viewModel.selectedCuisines.contains(cuisine)
                ) {
                    viewModel.toggleCuisine(cuisine)
                }
            }
        }
    }

    // MARK: - Sort Section

    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sort By")
                .font(.headline)

            Picker("Sort By", selection: $viewModel.sortOption) {
                ForEach(MerchantSortOption.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Distance Section

    private var distanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Distance")
                    .font(.headline)

                Spacer()

                Text(String(format: "%.1f mi", searchRadius))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Slider(
                value: $searchRadius,
                in: 0.5...Constants.Map.maxSearchRadiusMiles,
                step: 0.5
            ) {
                Text("Search Radius")
            }
            .tint(Color.brandPrimary)
            .onChange(of: searchRadius) { _, newValue in
                viewModel.updateSearchRadius(newValue)
            }
        }
    }

    // MARK: - Apply Button

    private var applyButton: some View {
        Button(action: onApply) {
            Text("Apply Filters")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

#Preview {
    @Previewable @State var viewModel = DiscoveryViewModel()

    FilterSheetView(viewModel: viewModel) {}
}
