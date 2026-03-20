import SwiftUI

struct DiscoveryView: View {
    @Environment(ServiceContainer.self) private var services
    @Environment(Router.self) private var router

    @State private var viewModel = DiscoveryViewModel()
    @State private var showFilterSheet = false
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 0) {
            headerControls

            if viewModel.isLoading && viewModel.merchants.isEmpty {
                LoadingView(message: "Finding nearby restaurants...")
            } else if let error = viewModel.error, viewModel.merchants.isEmpty {
                ErrorView(
                    message: "Could not load merchants",
                    description: error.localizedDescription
                ) {
                    Task { await viewModel.loadMerchants(using: services) }
                }
            } else if viewModel.filteredMerchants.isEmpty {
                EmptyStateView(
                    systemImage: "magnifyingglass",
                    title: "No Results",
                    subtitle: "Try adjusting your filters or search query."
                )
            } else if viewModel.isMapMode {
                MapDiscoveryView(merchants: viewModel.filteredMerchants)
            } else {
                ListDiscoveryView(merchants: viewModel.filteredMerchants)
            }
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search restaurants, cuisines..."
        )
        .onChange(of: viewModel.searchText) { _, newValue in
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled else { return }
                await viewModel.search(using: services)
            }
        }
        .task {
            await viewModel.loadMerchants(using: services)
        }
        .bottomSheet(isPresented: $showFilterSheet) {
            FilterSheetView(viewModel: viewModel) {
                showFilterSheet = false
                Task { await viewModel.applyFilters(using: services) }
            }
        }
    }

    // MARK: - Header Controls

    private var headerControls: some View {
        VStack(spacing: 12) {
            HStack {
                mapListToggle
                Spacer()
                filterButton
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)

            if !viewModel.selectedCuisines.isEmpty {
                cuisineChipsRow
            }
        }
        .padding(.vertical, 8)
    }

    private var mapListToggle: some View {
        Button {
            withAnimation(.easeInOut(duration: Constants.Animation.standard)) {
                viewModel.isMapMode.toggle()
            }
        } label: {
            Label(
                viewModel.isMapMode ? "List" : "Map",
                systemImage: viewModel.isMapMode ? "list.bullet" : "map"
            )
            .font(.subheadline.weight(.medium))
            .foregroundStyle(Color.brandPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.brandPrimary.opacity(0.12), in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var filterButton: some View {
        Button {
            showFilterSheet = true
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "slider.horizontal.3")
                Text("Filters")
                if !viewModel.selectedCuisines.isEmpty {
                    Text("\(viewModel.selectedCuisines.count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.brandAccent, in: Circle())
                }
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.surfaceSecondary, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var cuisineChipsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(viewModel.selectedCuisines).sorted(by: { $0.displayName < $1.displayName })) { cuisine in
                    CuisineChipView(
                        cuisine: cuisine,
                        isSelected: true
                    ) {
                        viewModel.toggleCuisine(cuisine)
                        Task { await viewModel.applyFilters(using: services) }
                    }
                }
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
        }
    }
}

#Preview {
    NavigationStack {
        DiscoveryView()
    }
    .environment(ServiceContainer.mock)
    .environment(Router())
}
