import Foundation

enum BikePointError: LocalizedError {
    case connectivity
    case timeout
    case rateLimited
    case server
    case invalidResponse
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .connectivity:
            "Check your internet connection."
        case .timeout:
            "The request timed out. Try again."
        case .rateLimited:
            "Too many requests. Try again shortly."
        case .server:
            "The service is temporarily unavailable."
        case .invalidResponse:
            "The service returned an invalid response."
        case .decoding:
            "Unable to process the server response."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }
}
