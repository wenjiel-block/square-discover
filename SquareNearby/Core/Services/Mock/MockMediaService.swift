import Foundation

final class MockMediaService: MediaServiceProtocol, @unchecked Sendable {

    func uploadImage(_ imageData: Data) async throws -> URL {
        try await Task.sleep(for: .milliseconds(500))
        // Return a deterministic placeholder URL based on data size
        let seed = imageData.count
        return URL(string: "https://picsum.photos/seed/upload\(seed)/800/600")!
    }

    func uploadVideo(_ localURL: URL) async throws -> URL {
        try await Task.sleep(for: .milliseconds(500))
        // Return a placeholder video URL
        return URL(string: "https://example.com/videos/uploaded_\(UUID().uuidString.prefix(8)).mp4")!
    }

    func generateThumbnail(from sourceURL: URL) async throws -> URL {
        try await Task.sleep(for: .milliseconds(300))
        // Return a placeholder thumbnail
        let seed = sourceURL.lastPathComponent.hashValue
        return URL(string: "https://picsum.photos/seed/thumb\(abs(seed))/400/300")!
    }
}
