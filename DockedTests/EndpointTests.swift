import NetworkKit
import Testing
@testable import Docked

struct EndpointTests {
    @Test func fetchDocksIsAGetForBikePoint() {
        let endpoint = Endpoint<[BikePoint]>.fetchDocks()

        #expect(endpoint.path == "BikePoint")
        #expect(endpoint.method == .get)
        #expect(endpoint.queryItems.isEmpty)
        #expect(endpoint.body == nil)
    }
}
