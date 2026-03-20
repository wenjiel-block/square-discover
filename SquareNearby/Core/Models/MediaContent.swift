import Foundation

enum MediaType: String, Codable, Hashable, Sendable {
    case video
    case image
}

struct MediaContent: Codable, Hashable, Identifiable, Sendable {
    let id: UUID
    let type: MediaType
    let url: URL
    let thumbnailURL: URL?
    let aspectRatio: Double
    let durationSeconds: Double?

    init(
        id: UUID = UUID(),
        type: MediaType,
        url: URL,
        thumbnailURL: URL? = nil,
        aspectRatio: Double = 1.0,
        durationSeconds: Double? = nil
    ) {
        self.id = id
        self.type = type
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.aspectRatio = aspectRatio
        self.durationSeconds = durationSeconds
    }

    var isVideo: Bool {
        type == .video
    }

    var formattedDuration: String? {
        guard let durationSeconds else { return nil }
        let minutes = Int(durationSeconds) / 60
        let seconds = Int(durationSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
