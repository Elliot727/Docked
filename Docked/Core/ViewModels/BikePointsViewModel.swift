import Observation

@Observable
@MainActor
final class BikePointsViewModel {
    private let service: BikePointService
    
    init(service: BikePointService) {
        self.service = service
    }
    
    private(set) var state: AsyncState<[BikePoint]> = .loading(previous: nil)
    
    func fetchAll() async {
        let previous = state.value
        state = .loading(previous: previous)
        do {
            let bikes = try await service.fetchAll()
            state = .loaded(bikes)
        }
        catch {
            state = .failed(error)
        }
    }
}
