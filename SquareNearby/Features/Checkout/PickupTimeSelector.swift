import SwiftUI

struct PickupTimeSelector: View {
    let timeSlots: [Date]
    @Binding var selectedTime: Date
    @Binding var isASAP: Bool

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                // ASAP pill
                timePill(label: "ASAP", isSelected: isASAP) {
                    isASAP = true
                }

                // Time slot pills
                ForEach(timeSlots, id: \.self) { slot in
                    let isSelected = !isASAP && Calendar.current.isDate(selectedTime, equalTo: slot, toGranularity: .minute)

                    timePill(label: timeFormatter.string(from: slot), isSelected: isSelected) {
                        isASAP = false
                        selectedTime = slot
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    // MARK: - Subviews

    private func timePill(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected ? Color.brandPrimary : Color.surfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var selectedTime = Date.now
    @Previewable @State var isASAP = true

    let calendar = Calendar.current
    let slots: [Date] = (0..<8).compactMap { i in
        calendar.date(byAdding: .minute, value: (i + 1) * 15, to: .now)
    }

    PickupTimeSelector(
        timeSlots: slots,
        selectedTime: $selectedTime,
        isASAP: $isASAP
    )
    .padding()
}
