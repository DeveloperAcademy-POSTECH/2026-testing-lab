public struct ThreeSixNineGame {
    public init() {}

    public func play(_ number: Int) -> String {
        // Count how many digits should become claps.
        let clapCount = String(number).filter { digit in
            digit == "3" || digit == "6" || digit == "9"
        }.count

        // If no clap digits are found, return the original number.
        guard clapCount > 0 else {
            return String(number)
        }

        // Convert each matching digit into one "clap".
        return Array(repeating: "clap", count: clapCount).joined(separator: " ")
    }
}
