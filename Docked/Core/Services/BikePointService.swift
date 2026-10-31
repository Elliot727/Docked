import Foundation
import NetworkKit

struct BikePointService {
    private let client: any NetworkService
    
    init(client: any NetworkService) {
        self.client = client
    }
    
    func fetchAll() async throws -> [BikePoint] {
        try await client.request(.fetchDocks())
    }
}
