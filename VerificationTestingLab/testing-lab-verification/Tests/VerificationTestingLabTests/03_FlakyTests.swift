import Testing
import VerificationTestingLab

@Suite("Experiment 3 - Flaky Tests")
struct FlakyTests {
    @Test(
        "Disabled flaky example: exact random output is unreliable",
        .disabled("Re-enable to see that this test only passes when the random value happens to be 1234.")
    )
    func disabledFlakyExample() {
        // 1. Generate an ID using real randomness.
        let id = RandomIDGenerator().makeID()

        // 2. This is intentionally weak test design.
        // It expects one exact random value, so it will usually fail even when
        // the production code is correct.
        #expect(id == "user-1234")
    }

    @Test("Dependency injection makes random behavior deterministic")
    func deterministicIDGeneration() {
        // 1. Inject a fixed randomizer so the test controls the generated number.
        let generator = RandomIDGenerator(randomizer: FixedRandomizer(1234))

        // 2. Verify exact output because randomness has been removed.
        #expect(generator.makeID() == "user-1234")
        #expect(generator.makeID(prefix: "session") == "session-1234")
    }

    @Test("A useful randomized test checks stable properties, not exact luck")
    func randomizedTestChecksShapeOnly() throws {
        // 1. Use the real random generator.
        let generator = RandomIDGenerator()

        // 2. Generate an ID and parse the numeric suffix for later assertions.
        let id = generator.makeID()
        let number = try #require(generator.parseNumber(from: id))

        // 3. Verify stable rules that should be true for every random value.
        #expect(id.hasPrefix("user-"))
        #expect((1000...9999).contains(number))
    }
}
