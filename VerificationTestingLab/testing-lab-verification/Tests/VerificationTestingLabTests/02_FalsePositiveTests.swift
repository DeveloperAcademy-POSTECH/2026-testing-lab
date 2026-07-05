import Testing
import VerificationTestingLab

@Suite("Experiment 2 - False Positives")
struct FalsePositiveTests {
    @Test("False positive example: expected data alone proves nothing")
    func expectedValueWithoutSystemUnderTest() {
        // 1. Prepare an expected value.
        let expected = "clap clap"

        // 2. Compare the expected value to itself.
        // This assertion passes without calling ThreeSixNineGame at all.
        // It proves only that this test file contains the string "clap clap".
        #expect(expected == "clap clap")
    }

    @Test("Stronger alternative: exercise the system under test")
    func exerciseSystemUnderTest() {
        // 1. Call the production code that we actually want to verify.
        let result = ThreeSixNineGame().play(99)

        // 2. Compare the result to an independently chosen expected value.
        #expect(result == "clap clap")
    }

    @Test("False positive example: duplicating production logic in the test")
    func expectedValueGeneratedWithSameLogic() {
        // 1. Choose sample input.
        let number = 38

        // 2. Build the expected value by repeating the production algorithm.
        // This is risky because the test can copy the same bug as the app code.
        let expected = String(number)
            .filter { $0 == "3" || $0 == "6" || $0 == "9" }
            .map { _ in "clap" }
            .joined(separator: " ")

        // 3. Compare production output to the duplicated algorithm.
        // This passes, but it is misleading. If production and test code both
        // make the same mistake, the test can agree with the bug.
        #expect(ThreeSixNineGame().play(number) == expected)
    }

    @Test("Stronger alternative: use independently chosen examples")
    func independentlyChosenExpectedValue() {
        // 1. Use examples written from the game rules, not copied code.
        // 2. Check both clap and non-clap cases so an incorrect digit is caught.
        #expect(ThreeSixNineGame().play(38) == "clap")
        #expect(ThreeSixNineGame().play(89) == "clap")
        #expect(ThreeSixNineGame().play(88) == "88")
    }

    @Test("Use #require when a later assertion depends on an optional value")
    func requireValidCredentialsBeforeInspectingThem() throws {
        // 1. Create the validator that parses valid login input.
        let validator = LoginValidator()

        // 2. Require a non-nil result before making detailed assertions.
        // If this is nil, the test stops here with a useful failure.
        let credentials = try #require(validator.credentials(from: [
            "username": "lee",
            "password": "trustworthy"
        ]))

        // 3. Verify the exact credentials returned from the validator.
        #expect(credentials == Credentials(username: "lee", password: "trustworthy"))
    }

    // Mutation validation:
    // BUG: Treat digit 8 as a clap digit.
    // The duplicated-logic test above would not catch that bug if copied in both
    // places. The independent examples for 88 and 89 would catch it because they
    // specify behavior from the rules, not from the implementation.
}
