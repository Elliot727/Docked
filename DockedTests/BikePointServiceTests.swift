import Testing
@testable import Docked

@MainActor
struct BikePointServiceTests {
    @Test func fetchAllRequestsBikePoint() async throws {
        let client = StubNetworkService()
        let dock = makeDock(id: "BikePoints_1")
        client.setBikes(.success([dock]))
        let service = BikePointService(client: client)

        let docks = try await service.fetchAll()

        #expect(docks.map(\.id) == ["BikePoints_1"])
        #expect(client.paths == ["BikePoint"])
    }

    @Test func fetchAllThrowsTheClientError() async {
        let client = StubNetworkService()
        client.setBikes(.failure(StubError.offline))
        let service = BikePointService(client: client)

        await #expect(throws: StubError.offline) {
            try await service.fetchAll()
        }
    }
}
