import SwiftUI

struct MerchantHoursView: View {
    let hours: [BusinessHours]

    /// Returns the current weekday as 1 = Sunday ... 7 = Saturday, matching BusinessHours.dayOfWeek.
    private var todayWeekday: Int {
        Calendar.current.component(.weekday, from: .now)
    }

    /// All days of the week (1-7) sorted starting from Monday (2) through Sunday (1).
    private var sortedHours: [DayHoursEntry] {
        let displayOrder = [2, 3, 4, 5, 6, 7, 1]
        return displayOrder.map { day in
            let match = hours.first { $0.dayOfWeek == day }
            return DayHoursEntry(dayOfWeek: day, hours: match)
        }
    }

    var body: some View {
        if hours.isEmpty {
            Text("Hours not available")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(sortedHours) { entry in
                    dayRow(entry)
                }
            }
        }
    }

    // MARK: - Day Row

    private func dayRow(_ entry: DayHoursEntry) -> some View {
        let isToday = entry.dayOfWeek == todayWeekday

        return HStack {
            Text(entry.dayName)
                .font(isToday ? .subheadline.weight(.semibold) : .subheadline)
                .frame(width: 90, alignment: .leading)

            if let hours = entry.hours {
                Text(hours.formattedHours)
                    .font(isToday ? .subheadline.weight(.semibold) : .subheadline)
                    .foregroundStyle(isToday ? Color.primary : .secondary)
            } else {
                Text("Closed")
                    .font(isToday ? .subheadline.weight(.semibold) : .subheadline)
                    .foregroundStyle(.red)
            }

            Spacer()

            if isToday {
                Text("Today")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.brandPrimary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.brandPrimary.opacity(0.12), in: Capsule())
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Day Hours Entry

private struct DayHoursEntry: Identifiable {
    let dayOfWeek: Int
    let hours: BusinessHours?

    var id: Int { dayOfWeek }

    var dayName: String {
        switch dayOfWeek {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Unknown"
        }
    }
}

#Preview {
    MerchantHoursView(hours: [
        BusinessHours(dayOfWeek: 1, openTime: "09:00", closeTime: "17:00"),
        BusinessHours(dayOfWeek: 2, openTime: "07:30", closeTime: "19:00"),
        BusinessHours(dayOfWeek: 3, openTime: "07:30", closeTime: "19:00"),
        BusinessHours(dayOfWeek: 4, openTime: "07:30", closeTime: "19:00"),
        BusinessHours(dayOfWeek: 5, openTime: "07:30", closeTime: "21:00"),
        BusinessHours(dayOfWeek: 6, openTime: "07:30", closeTime: "21:00"),
        BusinessHours(dayOfWeek: 7, openTime: "08:00", closeTime: "18:00"),
    ])
    .padding()
}
