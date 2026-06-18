import Testing
import VerificationTestingLab

struct PlayCase: Sendable {
    // One row in the parameterized test table.
    let number: Int
    let expected: String
}

@Suite("Experiment 5 - Parameterized Tests")
struct ParameterizedTests {
    @Test(
        "Three-six-nine examples",
        arguments: [
            PlayCase(number: 1, expected: "1"),
            PlayCase(number: 3, expected: "clap"),
            PlayCase(number: 33, expected: "clap clap"),
            PlayCase(number: 28, expected: "28"),
            PlayCase(number: 99, expected: "clap clap")
        ]
    )
    func playReturnsExpectedValue(sample: PlayCase) {
        // 1. Swift Testing runs this function once for each PlayCase above.
        // 2. Compare the game result to that row's expected value.
        #expect(ThreeSixNineGame().play(sample.number) == sample.expected)
    }

    @Test(
        "Single-clap numbers",
        arguments: [
            PlayCase(number: 6, expected: "clap"),
            PlayCase(number: 9, expected: "clap"),
            PlayCase(number: 13, expected: "clap"),
            PlayCase(number: 16, expected: "clap")
        ]
    )
    func singleClapCases(sample: PlayCase) {
        // 1. Reuse the same test shape for several single-clap examples.
        // 2. Each row becomes its own reported test case.
        #expect(ThreeSixNineGame().play(sample.number) == sample.expected)
    }

    // Parameterized tests make it cheap to add examples. That matters for trust:
    // a single example might accidentally pass, but a table of independent cases
    // is more likely to catch a broken rule.
}
