public protocol IntegerRandomizing: Sendable {
    func nextInt(in range: ClosedRange<Int>) -> Int
}

public struct SystemRandomizer: IntegerRandomizing {
    public init() {}

    public func nextInt(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range)
    }
}

public struct FixedRandomizer: IntegerRandomizing {
    private let value: Int

    public init(_ value: Int) {
        self.value = value
    }

    public func nextInt(in range: ClosedRange<Int>) -> Int {
        min(max(value, range.lowerBound), range.upperBound)
    }
}

public struct RandomIDGenerator {
    private let randomizer: any IntegerRandomizing

    public init(randomizer: any IntegerRandomizing = SystemRandomizer()) {
        // Production uses SystemRandomizer; tests can inject FixedRandomizer.
        self.randomizer = randomizer
    }

    public func makeID(prefix: String = "user") -> String {
        // Build a readable ID from a prefix and a four-digit number.
        "\(prefix)-\(randomizer.nextInt(in: 1000...9999))"
    }

    public func parseNumber(from id: String) -> Int? {
        // Pull out the part after the final "-" so tests can inspect the range.
        Int(id.split(separator: "-").last ?? "")
    }
}
