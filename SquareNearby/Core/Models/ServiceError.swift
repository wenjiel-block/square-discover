import Foundation

enum ServiceError: Error, LocalizedError, Hashable {
    case networkError(underlying: String)
    case notFound
    case unauthorized
    case serverError(statusCode: Int)
    case decodingError
    case invalidInput(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkError(let underlying):
            return "Network error: \(underlying)"
        case .notFound:
            return "The requested resource was not found."
        case .unauthorized:
            return "You are not authorized to perform this action. Please sign in again."
        case .serverError(let statusCode):
            return "Server error (status \(statusCode)). Please try again later."
        case .decodingError:
            return "Failed to process the server response."
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }

    var isRetryable: Bool {
        switch self {
        case .networkError, .serverError, .unknown:
            return true
        case .notFound, .unauthorized, .decodingError, .invalidInput:
            return false
        }
    }
}
