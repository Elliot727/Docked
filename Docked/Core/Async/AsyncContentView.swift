import SwiftUI

struct AsyncContentView<Value, Content: View>: View {
    let state: AsyncState<Value>
    let content: (Value) -> Content
    let retry: () async -> Void
    
    init(state: AsyncState<Value>, @ViewBuilder content: @escaping (Value) -> Content, retry: @escaping () async -> Void) {
        self.state = state
        self.content = content
        self.retry = retry
    }
    
    var body: some View {
        switch state {
        case .loading(let previous):
            if let previous {
                content(previous)
            }
            else {
                ProgressView()
            }
        case .loaded(let value):
            content(value)
        case .failed(let error):
            Text(error.localizedDescription)
        }
    }
}
