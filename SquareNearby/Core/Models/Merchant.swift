import Foundation

struct BusinessHours: Codable, Hashable, Sendable {
    let dayOfWeek: Int // 1 = Sunday, 7 = Saturday
    let openTime: String // "HH:mm" format
    let closeTime: String // "HH:mm" format

    var dayName: String {
        switch dayOfWeek {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Unknown"
        }
    }

    var formattedHours: String {
        "\(formatTime(openTime)) - \(formatTime(closeTime))"
    }

    private func formatTime(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }
        let period = hour >= 12 ? "PM" : "AM"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        if minute == 0 {
            return "\(displayHour) \(period)"
        }
        return String(format: "%d:%02d %@", displayHour, minute, period)
    }
}

struct Merchant: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let description: String
    let cuisineTypes: [Cuisine]
    let location: Location
    let address: String
    let phoneNumber: String?
    let rating: Double
    let reviewCount: Int
    let priceLevel: PriceLevel
    let heroImageURL: URL?
    let logoURL: URL?
    let isVerified: Bool
    let hours: [BusinessHours]
    var isCurrentlyOpen: Bool
    let estimatedPickupTime: Int? // minutes
    let tags: [String]

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        cuisineTypes: [Cuisine] = [],
        location: Location,
        address: String,
        phoneNumber: String? = nil,
        rating: Double = 0.0,
        reviewCount: Int = 0,
        priceLevel: PriceLevel = .moderate,
        heroImageURL: URL? = nil,
        logoURL: URL? = nil,
        isVerified: Bool = false,
        hours: [BusinessHours] = [],
        isCurrentlyOpen: Bool = false,
        estimatedPickupTime: Int? = nil,
        tags: [String] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.cuisineTypes = cuisineTypes
        self.location = location
        self.address = address
        self.phoneNumber = phoneNumber
        self.rating = min(max(rating, 0.0), 5.0)
        self.reviewCount = reviewCount
        self.priceLevel = priceLevel
        self.heroImageURL = heroImageURL
        self.logoURL = logoURL
        self.isVerified = isVerified
        self.hours = hours
        self.isCurrentlyOpen = isCurrentlyOpen
        self.estimatedPickupTime = estimatedPickupTime
        self.tags = tags
    }

    var formattedRating: String {
        String(format: "%.1f", rating)
    }

    var formattedReviewCount: String {
        if reviewCount >= 1000 {
            return String(format: "%.1fK", Double(reviewCount) / 1000)
        }
        return "\(reviewCount)"
    }

    var formattedPickupTime: String? {
        guard let estimatedPickupTime else { return nil }
        return "\(estimatedPickupTime) min"
    }

    var primaryCuisine: Cuisine? {
        cuisineTypes.first
    }

    var cuisineDisplayText: String {
        cuisineTypes.map(\.displayName).joined(separator: ", ")
    }

    var todayHours: BusinessHours? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: .now)
        return hours.first { $0.dayOfWeek == weekday }
    }
}
