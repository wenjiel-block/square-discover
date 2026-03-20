import Foundation

extension String {
    /// Whether the string is empty or contains only whitespace.
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Whether the string is a valid email address format.
    var isValidEmail: Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return range(of: pattern, options: .regularExpression) != nil
    }

    /// Returns the string with leading and trailing whitespace removed.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Whether the string meets a minimum length requirement.
    func meetsMinimumLength(_ length: Int) -> Bool {
        count >= length
    }
}
