import Foundation

public struct Credentials: Equatable, Sendable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

public struct LoginValidator {
    public init() {}

    public func isValid(username: String, password: String) -> Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3
            && password.count >= 8
    }

    public func credentials(from input: [String: String]) -> Credentials? {
        guard
            let username = input["username"],
            let password = input["password"],
            isValid(username: username, password: password)
        else {
            return nil
        }

        return Credentials(username: username, password: password)
    }
}
