import SwiftUI

struct MultiDatePickerPlayground: View {
    @State private var selectedDates: Set<DateComponents> = []
    @State private var labelText = "Select Dates"
    @State private var useDateRange = false
    @State private var tintColor = Color.blue

    @Environment(\.calendar) var calendar

    var body: some View {
        ComponentPage(
            title: "MultiDatePicker",
            description: "A control for picking multiple dates. iOS 16+",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            if useDateRange {
                MultiDatePicker(labelText, selection: $selectedDates, in: dateRange)
                    .tint(tintColor)
            } else {
                MultiDatePicker(labelText, selection: $selectedDates)
                    .tint(tintColor)
            }

            Text("\(selectedDates.count) date(s) selected")
                .font(.caption)
                .foregroundStyle(.secondary)

            if !selectedDates.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(sortedDates, id: \.self) { components in
                            if let date = calendar.date(from: components) {
                                Text(date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(tintColor.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
    }

    private var sortedDates: [DateComponents] {
        selectedDates.sorted { lhs, rhs in
            guard let d1 = calendar.date(from: lhs),
                  let d2 = calendar.date(from: rhs) else { return false }
            return d1 < d2
        }
    }

    private var dateRange: Range<Date> {
        let today = Date()
        let thirtyDaysLater = calendar.date(byAdding: .day, value: 30, to: today)!
        return today..<thirtyDaysLater
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $labelText)

            ToggleControl(label: "Limit to 30 Days", isOn: $useDateRange)

            ColorControl(label: "Tint Color", color: $tintColor)

            Button("Clear Selection") {
                selectedDates.removeAll()
            }
            .buttonStyle(.bordered)
        }
    }

    private var generatedCode: String {
        var code = """
        // MultiDatePicker allows selecting multiple dates
        @State private var selectedDates: Set<DateComponents> = []

        """

        if useDateRange {
            code += """
            // Limit selection to a date range
            let dateRange = Date()...Date().addingTimeInterval(30 * 24 * 60 * 60)

            MultiDatePicker("\(labelText)", selection: $selectedDates, in: dateRange)
            """
        } else {
            code += """
            MultiDatePicker("\(labelText)", selection: $selectedDates)
            """
        }

        if tintColor != .blue {
            code += "\n    .tint(\(colorToCode(tintColor)))"
        }

        return code
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        if color == .orange { return ".orange" }
        if color == .purple { return ".purple" }
        if color == .pink { return ".pink" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        MultiDatePickerPlayground()
    }
}
