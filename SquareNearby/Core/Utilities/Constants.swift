import Foundation

enum Constants {

    enum Animation {
        /// Fast animations (0.2s) for micro-interactions.
        static let fast: Double = 0.2

        /// Standard animations (0.35s) for most transitions.
        static let standard: Double = 0.35

        /// Slow animations (0.5s) for modal presentations.
        static let slow: Double = 0.5
    }

    enum Pagination {
        /// Default number of items per page.
        static let defaultPageSize: Int = 20

        /// Number of items per page for the feed.
        static let feedPageSize: Int = 10

        /// Number of items per page for menus.
        static let menuPageSize: Int = 30
    }

    enum Layout {
        /// Standard horizontal padding.
        static let horizontalPadding: CGFloat = 16

        /// Standard vertical spacing between sections.
        static let sectionSpacing: CGFloat = 24

        /// Standard card corner radius.
        static let cardCornerRadius: CGFloat = 12

        /// Standard card shadow radius.
        static let cardShadowRadius: CGFloat = 4

        /// Minimum tap target size (44pt per Apple HIG).
        static let minTapTarget: CGFloat = 44
    }

    enum API {
        /// Base URL for the Square Nearby API.
        static let baseURL = "https://api.squarenearby.com/v1"

        /// Request timeout interval in seconds.
        static let requestTimeout: TimeInterval = 30

        /// Maximum number of retry attempts for failed requests.
        static let maxRetries: Int = 3
    }

    enum Cache {
        /// Maximum number of cached images.
        static let maxImageCount: Int = 100

        /// Cache expiration time in seconds (1 hour).
        static let expirationInterval: TimeInterval = 3600
    }

    enum Map {
        /// Default search radius in miles.
        static let defaultSearchRadiusMiles: Double = 5.0

        /// Maximum search radius in miles.
        static let maxSearchRadiusMiles: Double = 25.0
    }

    enum Content {
        /// Maximum caption length for posts.
        static let maxCaptionLength: Int = 500

        /// Maximum review length.
        static let maxReviewLength: Int = 2000

        /// Maximum number of images per post.
        static let maxImagesPerPost: Int = 10

        /// Maximum video duration in seconds.
        static let maxVideoDuration: TimeInterval = 60
    }
}
