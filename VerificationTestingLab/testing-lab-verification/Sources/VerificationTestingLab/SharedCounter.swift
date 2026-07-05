public final class SharedCounter: @unchecked Sendable {
    public static let shared = SharedCounter()

    private var value: Int

    public init(startingAt value: Int = 0) {
        self.value = value
    }

    @discardableResult
    public func increment() -> Int {
        value += 1
        return value
    }

    public func currentValue() -> Int {
        value
    }

    public func reset() {
        value = 0
    }
}
