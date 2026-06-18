import Testing
import VerificationTestingLab

@Suite("Experiment 6 - Test Validation Checklist")
struct TestValidationChecklistTests {
    @Test("Mutation: replacing 9 with 8 would be caught by independent examples")
    func mutationReplacingNineWithEightIsCaught() {
        // 1. Create the system under test once for this group of examples.
        let game = ThreeSixNineGame()

        // 2. Verify that 9 is a clap digit.
        #expect(game.play(9) == "clap")
        #expect(game.play(99) == "clap clap")

        // 3. Verify that 8 is not a clap digit.
        #expect(game.play(8) == "8")
        #expect(game.play(88) == "88")
    }

    @Test("Mutation: returning one clap for every match would be caught")
    func mutationReturningOnlyOneClapIsCaught() {
        // 1. Create the system under test.
        let game = ThreeSixNineGame()

        // 2. Check numbers with two clap digits so "clap" is not enough.
        #expect(game.play(33) == "clap clap")
        #expect(game.play(36) == "clap clap")
        #expect(game.play(39) == "clap clap")
    }

    @Test("Checklist example: exact, deterministic, isolated")
    func checklistExample() {
        // 1. Create fresh test-owned state and deterministic dependencies.
        let counter = SharedCounter()
        let generator = RandomIDGenerator(randomizer: FixedRandomizer(4321))

        // 2. Verify exact behavior, deterministic output, and isolated state.
        #expect(ThreeSixNineGame().play(28) == "28")
        #expect(generator.makeID() == "user-4321")
        #expect(counter.increment() == 1)
    }

    // Mutation validation notes:
    //
    // BUG:
    // Treat digit 8 as a clap digit.
    //
    // Tests that catch it:
    // - independentlyChosenExpectedValue checks 88 stays "88"
    // - mutationReplacingNineWithEightIsCaught checks 8 and 88 stay numeric
    // - parameterized 28 case checks unrelated digits do not clap
    //
    // Tests that may fail to detect it:
    // - weakAssertionExample only checks that 33 contains "clap"
    // - expectedValueWithoutSystemUnderTest never calls production code
    // - expectedValueGeneratedWithSameLogic can repeat the same mistake
}
