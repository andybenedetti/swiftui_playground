import SwiftUI

struct DatePickerPlayground: View {
    @State private var date = Date()
    @State private var label = "Select Date"
    @State private var displayedComponents = DatePickerComponentsOption.dateAndTime
    @State private var pickerStyle = DatePickerStyleOption.automatic

    enum DatePickerComponentsOption: String, CaseIterable {
        case date = "Date Only"
        case hourAndMinute = "Time Only"
        case dateAndTime = "Date & Time"

        var components: DatePickerComponents {
            switch self {
            case .date: .date
            case .hourAndMinute: .hourAndMinute
            case .dateAndTime: [.date, .hourAndMinute]
            }
        }
    }

    enum DatePickerStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case compact = "Compact"
        case graphical = "Graphical"
        case wheel = "Wheel"
    }

    var body: some View {
        ComponentPage(
            title: "DatePicker",
            description: "A control for selecting an absolute date and/or time.",
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
            datePickerView
                .padding(.horizontal, 20)

            Text(date.formatted())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var datePickerView: some View {
        let picker = DatePicker(
            label,
            selection: $date,
            displayedComponents: displayedComponents.components
        )

        switch pickerStyle {
        case .automatic:
            picker
        case .compact:
            picker.datePickerStyle(.compact)
        case .graphical:
            picker.datePickerStyle(.graphical)
        case .wheel:
            picker.datePickerStyle(.wheel)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $label)

            PickerControl(
                label: "Components",
                selection: $displayedComponents,
                options: DatePickerComponentsOption.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Style",
                selection: $pickerStyle,
                options: DatePickerStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        var code = """
        // DatePicker control
        @State private var date = Date()

        DatePicker(
            "\(label)",
            selection: $date,
            displayedComponents: \(componentsCode)
        )
        """

        switch pickerStyle {
        case .automatic:
            break
        case .compact:
            code += "\n.datePickerStyle(.compact)"
        case .graphical:
            code += "\n.datePickerStyle(.graphical)"
        case .wheel:
            code += "\n.datePickerStyle(.wheel)"
        }

        return code
    }

    private var componentsCode: String {
        switch displayedComponents {
        case .date: ".date"
        case .hourAndMinute: ".hourAndMinute"
        case .dateAndTime: "[.date, .hourAndMinute]"
        }
    }
}

#Preview {
    NavigationStack {
        DatePickerPlayground()
    }
}
