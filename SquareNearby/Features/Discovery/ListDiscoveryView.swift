import SwiftUI

struct ListDiscoveryView: View {
    let merchants: [Merchant]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(merchants) { merchant in
                    MerchantListRowView(merchant: merchant)
                }
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    ListDiscoveryView(merchants: [])
        .environment(Router())
}
