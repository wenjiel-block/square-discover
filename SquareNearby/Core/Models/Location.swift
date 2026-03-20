import Foundation
import CoreLocation

struct Location: Codable, Hashable, Sendable {
    let latitude: Double
    let longitude: Double
    var distanceMiles: Double?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    var formattedDistance: String? {
        guard let distanceMiles else { return nil }
        if distanceMiles < 0.1 {
            let feet = Int(distanceMiles * 5280)
            return "\(feet) ft"
        } else {
            return String(format: "%.1f mi", distanceMiles)
        }
    }

    func distance(to other: Location) -> Double {
        let from = CLLocation(latitude: latitude, longitude: longitude)
        let to = CLLocation(latitude: other.latitude, longitude: other.longitude)
        let meters = from.distance(from: to)
        return meters / 1609.344
    }
}
