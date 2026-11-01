import Observation

@Observable
@MainActor
final class BikePointsViewModel {

    private let service: BikePointService
    private var fetchTask: Task<Void, Never>?
    private var requestGeneration = 0

    private(set) var state: AsyncState<[BikePoint]> = .loading(previous: nil)

    init(service: BikePointService) {
        self.service = service
    }

    func fetchAll() async {
        fetchTask?.cancel()

        requestGeneration += 1
        let generation = requestGeneration

        let previous = state.value
        state = .loading(previous: previous)

        let task = Task {
            do {
                let bikes = try await service.fetchAll()

                try Task.checkCancellation()

                guard generation == requestGeneration else { return }

                state = .loaded(bikes)

            } catch is CancellationError {
                // Cancellation isn't a failure.

            } catch {
                guard !Task.isCancelled else { return }
                guard generation == requestGeneration else { return }

                state = .failed(error)
            }
        }

        fetchTask = task
        await task.value
    }
}
