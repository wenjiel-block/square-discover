import Foundation
import CoreLocation
import Combine

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    // Hardcoded to downtown San Francisco (near Union Square)
    private static let sfLocation = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        distanceMiles: 0
    )

    private let locationSubject = CurrentValueSubject<Location, Never>(sfLocation)

    var currentLocation: Location? {
        Self.sfLocation
    }

    var locationPublisher: AnyPublisher<Location, Never> {
        locationSubject.eraseToAnyPublisher()
    }

    func requestPermission() async {
        // Mock: permission is always granted
    }

    func startUpdating() {
        // Emit the hardcoded SF location immediately
        locationSubject.send(Self.sfLocation)
    }

    func stopUpdating() {
        // No-op in mock
    }
}
