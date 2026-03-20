import SwiftUI

enum TabItem: Int, CaseIterable, Identifiable {
    case feed = 0
    case discover = 1
    case createPost = 2
    case orders = 3
    case profile = 4

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .feed: return "Feed"
        case .discover: return "Discover"
        case .createPost: return "Create"
        case .orders: return "Orders"
        case .profile: return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .feed: return "play.circle.fill"
        case .discover: return "magnifyingglass"
        case .createPost: return "plus.circle.fill"
        case .orders: return "bag.fill"
        case .profile: return "person.fill"
        }
    }
}
