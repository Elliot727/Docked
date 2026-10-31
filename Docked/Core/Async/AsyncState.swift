enum AsyncState<Value> {
    case loading(previous: Value?)
    case loaded(Value)
    case failed(Error)
}

extension AsyncState {
    var value: Value? {
        switch self {
        case .loading(let previous): return previous
        case .loaded(let value): return value
        case .failed: return nil
        }
    }
}
