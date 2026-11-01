import SwiftUI

struct AsyncContentView<Value, Content: View>: View {
    let state: AsyncState<Value>
    let content: (Value) -> Content
    let retry: () async -> Void

    init(
        state: AsyncState<Value>,
        @ViewBuilder content: @escaping (Value) -> Content,
        retry: @escaping () async -> Void
    ) {
        self.state = state
        self.content = content
        self.retry = retry
    }

    var body: some View {
        if let value = state.value {
            // Loaded OR refreshing. One branch, so the ScrollView keeps its identity.
            content(value)
        } else if case .failed(let error) = state {
            VStack(spacing: Spacing.md) {
                Text(error.localizedDescription)
                    .multilineTextAlignment(.center)
                Button("Try again") {
                    Task { await retry() }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            // First load, nothing to show yet
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
