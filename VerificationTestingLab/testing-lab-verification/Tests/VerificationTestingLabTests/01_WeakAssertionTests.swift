import Testing
import VerificationTestingLab

@Suite("Experiment 1 - Weak Assertions")
struct WeakAssertionTests {
    @Test("A weak assertion can pass while missing the exact behavior")
    func weakAssertionExample() {
        // 1. Run the game with a number that should produce two claps.
        let result = ThreeSixNineGame().play(33)

        // 2. Check only that the result contains "clap".
        // This passes for the correct implementation, but it is weak:
        // "clap", "clap clap", and "wrong clap text" could all satisfy it.
        #expect(result.contains("clap"))
    }

    @Test("A strong assertion verifies the full expected output")
    func strongAssertionExample() {
        // 1. Run the same behavior as the weak test.
        let result = ThreeSixNineGame().play(33)

        // 2. Compare the entire result to the exact expected value.
        #expect(result == "clap clap")
    }

    // To validate this test, intentionally break ThreeSixNineGame.play(_:) so it
    // always returns "clap" for any number containing a clap digit. The weak test
    // above will still pass for 33, while this exact assertion will fail.
}
