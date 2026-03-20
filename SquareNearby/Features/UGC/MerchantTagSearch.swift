import SwiftUI

struct MerchantTagSearch: View {
    var onSelect: (Merchant) -> Void
    @State private var searchText: String = ""
    @State private var results: [Merchant] = []
    @State private var isSearching = false
    @Environment(\.services) private var services
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            if isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            } else if results.isEmpty && !searchText.isEmpty {
                Text("No merchants found.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(results) { merchant in
                    Button {
                        onSelect(merchant)
                    } label: {
                        HStack(spacing: 12) {
                            AsyncImageView(url: merchant.logoURL, cornerRadius: 6)
                                .frame(width: 40, height: 40)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(merchant.name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.primary)

                                Text(merchant.cuisineDisplayText)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Tag Merchant")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search merchants...")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onChange(of: searchText) { _, query in
            Task {
                await search(query: query)
            }
        }
    }

    @MainActor
    private func search(query: String) async {
        guard !query.isEmpty else {
            results = []
            return
        }

        isSearching = true
        do {
            results = try await services.merchantService.searchMerchants(query: query)
        } catch {
            results = []
        }
        isSearching = false
    }
}

#Preview {
    NavigationStack {
        MerchantTagSearch { _ in }
            .environment(\.services, .mock)
    }
}
