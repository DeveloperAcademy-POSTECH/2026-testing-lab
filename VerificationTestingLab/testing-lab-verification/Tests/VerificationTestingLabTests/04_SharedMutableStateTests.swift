import Testing
import VerificationTestingLab

@Suite("Experiment 4 - Shared Mutable State")
struct SharedMutableStateTests {
    @Test(
        "Disabled order-dependent setup: resets and increments shared state",
        .disabled("Re-enable with the next disabled test to demonstrate hidden coupling through shared state.")
    )
    func disabledOrderDependentSetup() {
        // 1. Reset the shared singleton.
        SharedCounter.shared.reset()

        // 2. This passes by itself, but it leaves shared state behind.
        #expect(SharedCounter.shared.increment() == 1)
    }

    @Test(
        "Disabled order-dependent assertion: assumes another test already ran",
        .disabled("Re-enable to see that this test depends on execution order and fails when run alone.")
    )
    func disabledOrderDependentAssertion() {
        // 1. This test assumes disabledOrderDependentSetup() ran first.
        // Swift Testing does not guarantee that order.
        #expect(SharedCounter.shared.increment() == 2)
    }

    @Test("Resetting shared state avoids leaking behavior between tests")
    func resetSharedCounterInsideTest() {
        // 1. Reset the singleton before using it so earlier tests cannot leak in.
        SharedCounter.shared.reset()

        // 2. Verify the behavior this test owns.
        #expect(SharedCounter.shared.increment() == 1)
        #expect(SharedCounter.shared.increment() == 2)

        // 3. Reset again so this test does not leak state into later tests.
        SharedCounter.shared.reset()
    }

    @Test("Best alternative: create isolated state per test")
    func isolatedCounterPerTest() {
        // 1. Create a fresh counter owned only by this test.
        let counter = SharedCounter()

        // 2. Verify the counter without depending on any global state.
        #expect(counter.currentValue() == 0)
        #expect(counter.increment() == 1)
        #expect(counter.increment() == 2)
    }
}
