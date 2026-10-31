import Testing
@testable import Docked

@MainActor
struct BikePointsViewModelTests {
    @Test func startsLoadingWithNoPreviousValue() {
        let model = BikePointsViewModel(service: BikePointService(client: StubNetworkService()))

        guard case .loading(nil) = model.state else {
            Issue.record("expected initial loading state")
            return
        }
        #expect(model.state.value == nil)
    }

    @Test func fetchAllStoresLoadedDocks() async {
        let client = StubNetworkService()
        client.setBikes(.success([makeDock(id: "BikePoints_1"), makeDock(id: "BikePoints_2")]))
        let model = BikePointsViewModel(service: BikePointService(client: client))

        await model.fetchAll()

        guard case .loaded(let docks) = model.state else {
            Issue.record("expected loaded state")
            return
        }
        #expect(docks.map(\.id) == ["BikePoints_1", "BikePoints_2"])
        #expect(client.paths == ["BikePoint"])
    }

    @Test func fetchAllStoresTheFailure() async {
        let client = StubNetworkService()
        client.setBikes(.failure(StubError.offline))
        let model = BikePointsViewModel(service: BikePointService(client: client))

        await model.fetchAll()

        guard case .failed(let error) = model.state else {
            Issue.record("expected failed state")
            return
        }
        #expect(error as? StubError == .offline)
        #expect(model.state.value == nil)
    }

    @Test func refreshKeepsThePreviousListUntilTheNextResponse() async {
        let client = StubNetworkService()
        client.setBikes(.success([makeDock(id: "BikePoints_1")]))
        let model = BikePointsViewModel(service: BikePointService(client: client))
        await model.fetchAll()

        let pause = Pause()
        client.pause = pause
        client.setBikes(.success([makeDock(id: "BikePoints_2")]))
        let refresh = Task { await model.fetchAll() }
        await pause.waitUntilEntered()

        guard case .loading(let previous) = model.state else {
            Issue.record("expected loading with the previous list")
            refresh.cancel()
            pause.open()
            return
        }
        #expect(previous?.map(\.id) == ["BikePoints_1"])

        pause.open()
        await refresh.value

        guard case .loaded(let docks) = model.state else {
            Issue.record("expected the refreshed list")
            return
        }
        #expect(docks.map(\.id) == ["BikePoints_2"])
    }

    @Test func failedRefreshDropsThePreviousList() async {
        let client = StubNetworkService()
        client.setBikes(.success([makeDock(id: "BikePoints_1")]))
        let model = BikePointsViewModel(service: BikePointService(client: client))
        await model.fetchAll()

        client.setBikes(.failure(StubError.offline))
        await model.fetchAll()

        guard case .failed(let error) = model.state else {
            Issue.record("expected failed refresh")
            return
        }
        #expect(error as? StubError == .offline)
        #expect(model.state.value == nil)
    }
}
