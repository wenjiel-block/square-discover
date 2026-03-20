import Foundation

extension Int {
    /// Converts a value in cents to a formatted price string (e.g., 1299 -> "$12.99").
    var formattedAsCurrency: String {
        let dollars = Double(self) / 100.0
        return String(format: "$%.2f", dollars)
    }

    /// Converts a value in cents to a formatted price string without trailing zeros (e.g., 1200 -> "$12").
    var formattedAsCurrencyCompact: String {
        let dollars = Double(self) / 100.0
        if dollars.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "$%.0f", dollars)
        }
        return String(format: "$%.2f", dollars)
    }
}
