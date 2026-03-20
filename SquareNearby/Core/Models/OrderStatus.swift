import Foundation

enum OrderStatus: String, Codable, Hashable, CaseIterable, Sendable {
    case placed
    case confirmed
    case preparing
    case ready
    case pickedUp
    case cancelled

    var displayName: String {
        switch self {
        case .placed: return "Placed"
        case .confirmed: return "Confirmed"
        case .preparing: return "Preparing"
        case .ready: return "Ready for Pickup"
        case .pickedUp: return "Picked Up"
        case .cancelled: return "Cancelled"
        }
    }

    var systemImage: String {
        switch self {
        case .placed: return "clock.fill"
        case .confirmed: return "checkmark.circle.fill"
        case .preparing: return "frying.pan.fill"
        case .ready: return "bag.fill"
        case .pickedUp: return "hand.thumbsup.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }

    var isActive: Bool {
        switch self {
        case .placed, .confirmed, .preparing, .ready:
            return true
        case .pickedUp, .cancelled:
            return false
        }
    }

    var sortOrder: Int {
        switch self {
        case .placed: return 0
        case .confirmed: return 1
        case .preparing: return 2
        case .ready: return 3
        case .pickedUp: return 4
        case .cancelled: return 5
        }
    }
}
