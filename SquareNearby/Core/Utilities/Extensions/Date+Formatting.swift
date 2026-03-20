import Foundation

extension Date {
    /// Returns a relative time string such as "2h ago", "yesterday", or "3d ago".
    var relativeTimeString: String {
        let now = Date.now
        let interval = now.timeIntervalSince(self)

        guard interval >= 0 else { return "just now" }

        let seconds = Int(interval)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7

        if seconds < 60 {
            return "just now"
        } else if minutes < 60 {
            return "\(minutes)m ago"
        } else if hours < 24 {
            return "\(hours)h ago"
        } else if days == 1 {
            return "yesterday"
        } else if days < 7 {
            return "\(days)d ago"
        } else if weeks < 4 {
            return "\(weeks)w ago"
        } else {
            return shortDateString
        }
    }

    /// Returns a short date string formatted as "MMM d, yyyy" (e.g. "Jan 5, 2025").
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Returns a time-only string formatted as "h:mm a" (e.g. "2:30 PM").
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }

    /// Returns a combined short date and time string.
    var shortDateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
