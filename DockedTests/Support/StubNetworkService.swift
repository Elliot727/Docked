import Foundation
import NetworkKit
@testable import Docked

enum StubError: Error, Equatable {
    case typeMismatch
    case offline
}

final class Pause: @unchecked Sendable {
    private let lock = NSLock()
    private var continuation: CheckedContinuation<Void, Never>?
    private var enteredContinuation: CheckedContinuation<Void, Never>?
    private var isOpen = false
    private var hasEntered = false

    func wait() async {
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            lock.lock()
            hasEntered = true
            let entered = enteredContinuation
            enteredContinuation = nil
            if isOpen {
                lock.unlock()
                entered?.resume()
                cont.resume()
                return
            }
            continuation = cont
            lock.unlock()
            entered?.resume()
        }
    }

    func waitUntilEntered() async {
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            lock.lock()
            if hasEntered {
                lock.unlock()
                cont.resume()
                return
            }
            enteredContinuation = cont
            lock.unlock()
        }
    }

    func open() {
        lock.lock()
        isOpen = true
        let cont = continuation
        continuation = nil
        lock.unlock()
        cont?.resume()
    }
}

final class StubNetworkService: NetworkService, @unchecked Sendable {
    private let lock = NSLock()
    private var bikesResult: Result<[BikePoint], any Error> = .success([])
    private var recordedPaths: [String] = []
    var pause: Pause?

    func setBikes(_ result: Result<[BikePoint], any Error>) {
        lock.lock()
        bikesResult = result
        lock.unlock()
    }

    var paths: [String] {
        lock.lock()
        defer { lock.unlock() }
        return recordedPaths
    }

    func request<Response: Decodable>(
        _ endpoint: Endpoint<Response>
    ) async throws -> Response {
        let result = record(endpoint.path)
        if let pause {
            await pause.wait()
        }
        let bikes = try result.get()
        guard let response = bikes as? Response else {
            throw StubError.typeMismatch
        }
        return response
    }

    func request(_ endpoint: Endpoint<Void>) async throws {
        _ = record(endpoint.path)
    }

    func requestWithResponse<Response: Decodable & Sendable>(
        _ endpoint: Endpoint<Response>
    ) async throws -> NetworkResponse<Response> {
        throw StubError.typeMismatch
    }

    func requestWithResponse(
        _ endpoint: Endpoint<Void>
    ) async throws -> NetworkResponse<Void> {
        throw StubError.typeMismatch
    }

    private func record(_ path: String) -> Result<[BikePoint], any Error> {
        lock.lock()
        recordedPaths.append(path)
        let result = bikesResult
        lock.unlock()
        return result
    }
}
