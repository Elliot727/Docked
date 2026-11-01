import Foundation
import NetworkKit

struct BikePointService {
    private let client: any NetworkService
    
    init(client: any NetworkService) {
        self.client = client
    }
    
    func fetchAll() async throws -> [BikePoint] {
        do {
            return try await client.request(.fetchDocks())
        } catch {
            if error is CancellationError {
                throw error
            }

            if let urlError = error as? URLError,
               urlError.code == .cancelled {
                throw CancellationError()
            }

            throw mapError(error)
        }
    }
    
    private func mapError(_ error: Error) -> BikePointError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .cannotConnectToHost,
                 .cannotFindHost:
                return .connectivity

            case .timedOut:
                return .timeout

            default:
                return .unknown
            }
        }

        if let networkError = error as? NetworkError {
            switch networkError {
            case .httpError(let statusCode, _, _):
                switch statusCode {
                case 429:
                    return .rateLimited
                case 500...599:
                    return .server
                default:
                    return .unknown
                }

            case .invalidResponse:
                return .invalidResponse
            }
        }

        if error is DecodingError {
            return .decoding
        }

        return .unknown
    }
}
