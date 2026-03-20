import Foundation
import CoreLocation
import Combine

/// Defines the interface for accessing and monitoring the user's location.
protocol LocationServiceProtocol: AnyObject, Sendable {

    /// The most recently observed user location, or `nil` if not yet determined.
    var currentLocation: Location? { get }

    /// A publisher that emits location updates as they are received.
    var locationPublisher: AnyPublisher<Location, Never> { get }

    /// Requests the appropriate location permission from the user.
    func requestPermission() async

    /// Begins actively monitoring location updates.
    func startUpdating()

    /// Stops monitoring location updates to conserve battery.
    func stopUpdating()
}
