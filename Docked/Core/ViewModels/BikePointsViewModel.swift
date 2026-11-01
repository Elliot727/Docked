import Observation

@Observable
@MainActor
final class BikePointsViewModel {
    private let service: BikePointService
    private var fetchTask: Task<Void, Never>?

    private(set) var state: AsyncState<[BikePoint]> = .loading(previous: nil)

    init(service: BikePointService) {
        self.service = service
    }

    func fetchAll() async {
        fetchTask?.cancel()

        let previous = state.value
        state = .loading(previous: previous)

        let task = Task {
            do {
                let bikes = try await service.fetchAll()

                try Task.checkCancellation()

                state = .loaded(bikes)
            } catch is CancellationError {
                // Cancellation isn't a failure.
            } catch {
                guard !Task.isCancelled else { return }
                state = .failed(error)
            }
        }

        fetchTask = task
        await task.value
    }
}
