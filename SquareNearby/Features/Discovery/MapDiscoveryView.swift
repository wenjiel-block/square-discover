import SwiftUI
import MapKit

struct MapDiscoveryView: View {
    let merchants: [Merchant]

    @Environment(Router.self) private var router

    /// Default camera position centered on San Francisco.
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    @State private var selectedMerchant: Merchant?

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedMerchant) {
            ForEach(merchants) { merchant in
                Annotation(
                    merchant.name,
                    coordinate: merchant.location.coordinate,
                    anchor: .bottom
                ) {
                    annotationView(for: merchant)
                }
                .tag(merchant)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .onChange(of: selectedMerchant) { _, merchant in
            if let merchant {
                router.push(.merchantProfile(merchantId: merchant.id.uuidString))
                // Reset selection so the user can tap the same merchant again after navigating back.
                selectedMerchant = nil
            }
        }
        .onAppear {
            fitMapToMerchants()
        }
    }

    // MARK: - Annotation

    private func annotationView(for merchant: Merchant) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                if let cuisine = merchant.primaryCuisine {
                    Text(cuisine.emoji)
                        .font(.caption2)
                }
                Text(merchant.name)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.surfacePrimary, in: Capsule())
            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 8))
                .foregroundStyle(Color.surfacePrimary)
                .offset(y: -2)
        }
    }

    // MARK: - Helpers

    private func fitMapToMerchants() {
        guard !merchants.isEmpty else { return }

        let coordinates = merchants.map(\.location.coordinate)
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude

        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.4, 0.01),
            longitudeDelta: max((maxLon - minLon) * 1.4, 0.01)
        )

        withAnimation {
            cameraPosition = .region(MKCoordinateRegion(center: center, span: span))
        }
    }
}

#Preview {
    MapDiscoveryView(merchants: [])
        .environment(Router())
}
