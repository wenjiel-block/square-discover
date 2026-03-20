import Foundation

/// Defines the interface for uploading and processing media assets.
protocol MediaServiceProtocol: AnyObject, Sendable {

    /// Uploads an image and returns its remote URL.
    /// - Parameter imageData: The raw image data to upload.
    /// - Returns: The URL where the uploaded image can be accessed.
    func uploadImage(_ imageData: Data) async throws -> URL

    /// Uploads a video from a local file URL and returns its remote URL.
    /// - Parameter localURL: The local file URL of the video to upload.
    /// - Returns: The URL where the uploaded video can be accessed.
    func uploadVideo(_ localURL: URL) async throws -> URL

    /// Generates a thumbnail image from a video or image URL.
    /// - Parameter sourceURL: The URL of the source media.
    /// - Returns: The URL of the generated thumbnail.
    func generateThumbnail(from sourceURL: URL) async throws -> URL
}
