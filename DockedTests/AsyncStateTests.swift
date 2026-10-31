import Testing
@testable import Docked

struct AsyncStateTests {
    @Test func loadingWithoutPreviousHasNoValue() {
        let state = AsyncState<Int>.loading(previous: nil)
        #expect(state.value == nil)
    }

    @Test func loadingKeepsPreviousValue() {
        let state = AsyncState<Int>.loading(previous: 4)
        #expect(state.value == 4)
    }

    @Test func loadedExposesValue() {
        let state = AsyncState<String>.loaded("River Street")
        #expect(state.value == "River Street")
    }

    @Test func failedHasNoValue() {
        let state = AsyncState<Int>.failed(StubError.offline)
        #expect(state.value == nil)
    }
}
