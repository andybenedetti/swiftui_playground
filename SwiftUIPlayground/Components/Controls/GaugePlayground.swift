import SwiftUI

struct GaugePlayground: View {
    @State private var value: Double = 0.5
    @State private var minValue: Double = 0
    @State private var maxValue: Double = 100
    @State private var gaugeStyle = GaugeStyleOption.automatic
    @State private var label = "Speed"
    @State private var showCurrentValue = true
    @State private var tintColor = Color.blue

    enum GaugeStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case accessoryCircular = "Circular"
        case accessoryLinear = "Linear"
        case linearCapacity = "Linear Capacity"
    }

    var body: some View {
        ComponentPage(
            title: "Gauge",
            description: "A view that displays a value within a range.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/gauge")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        gaugeView
            .tint(tintColor)
    }

    @ViewBuilder
    private var gaugeView: some View {
        let gauge = Gauge(value: value, in: minValue...maxValue) {
            Text(label)
        } currentValueLabel: {
            if showCurrentValue {
                Text("\(Int(value))")
            }
        } minimumValueLabel: {
            Text("\(Int(minValue))")
        } maximumValueLabel: {
            Text("\(Int(maxValue))")
        }

        switch gaugeStyle {
        case .automatic:
            gauge
        case .accessoryCircular:
            gauge.gaugeStyle(.accessoryCircular)
        case .accessoryLinear:
            gauge.gaugeStyle(.accessoryLinear)
        case .linearCapacity:
            gauge.gaugeStyle(.linearCapacity)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $gaugeStyle,
                options: GaugeStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Value",
                value: $value,
                range: minValue...maxValue,
                format: "%.0f"
            )

            SliderControl(
                label: "Min",
                value: $minValue,
                range: 0...50,
                format: "%.0f"
            )

            SliderControl(
                label: "Max",
                value: $maxValue,
                range: 50...200,
                format: "%.0f"
            )

            TextFieldControl(label: "Label", text: $label)

            ToggleControl(label: "Show Current Value", isOn: $showCurrentValue)

            ColorControl(label: "Tint Color", color: $tintColor)
        }
    }

    private var generatedCode: String {
        var code = """
        Gauge(value: \(Int(value)), in: \(Int(minValue))...\(Int(maxValue))) {
            Text("\(label)")
        }
        """

        if showCurrentValue {
            code += """
             currentValueLabel: {
                Text("\\(Int(value))")
            }
            """
        }

        switch gaugeStyle {
        case .automatic:
            break
        case .accessoryCircular:
            code += "\n.gaugeStyle(.accessoryCircular)"
        case .accessoryLinear:
            code += "\n.gaugeStyle(.accessoryLinear)"
        case .linearCapacity:
            code += "\n.gaugeStyle(.linearCapacity)"
        }

        if tintColor != .blue {
            code += "\n.tint(\(colorToCode(tintColor)))"
        }

        return code
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        if color == .orange { return ".orange" }
        if color == .purple { return ".purple" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        GaugePlayground()
    }
}
