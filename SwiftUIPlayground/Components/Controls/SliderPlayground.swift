import SwiftUI

struct SliderPlayground: View {
    @State private var value = 50.0
    @State private var minValue = 0.0
    @State private var maxValue = 100.0
    @State private var step: Double? = nil
    @State private var useStep = false
    @State private var showLabel = true
    @State private var tintColor = Color.blue

    var body: some View {
        ComponentPage(
            title: "Slider",
            description: "A control for selecting a value from a bounded linear range.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/slider")!,
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
            if showLabel {
                sliderWithLabel
            } else {
                sliderOnly
            }

            Text("Value: \(value, specifier: "%.1f")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var sliderWithLabel: some View {
        if useStep, let step {
            Slider(value: $value, in: minValue...maxValue, step: step) {
                Text("Value")
            } minimumValueLabel: {
                Text("\(Int(minValue))")
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
            }
            .tint(tintColor)
        } else {
            Slider(value: $value, in: minValue...maxValue) {
                Text("Value")
            } minimumValueLabel: {
                Text("\(Int(minValue))")
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
            }
            .tint(tintColor)
        }
    }

    @ViewBuilder
    private var sliderOnly: some View {
        if useStep, let step {
            Slider(value: $value, in: minValue...maxValue, step: step)
                .tint(tintColor)
        } else {
            Slider(value: $value, in: minValue...maxValue)
                .tint(tintColor)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Minimum",
                value: $minValue,
                range: 0...99,
                format: "%.0f"
            )

            SliderControl(
                label: "Maximum",
                value: $maxValue,
                range: 1...200,
                format: "%.0f"
            )

            ToggleControl(label: "Use Step", isOn: $useStep)

            if useStep {
                SliderControl(
                    label: "Step",
                    value: Binding(
                        get: { step ?? 10 },
                        set: { step = $0 }
                    ),
                    range: 1...50,
                    format: "%.0f"
                )
            }

            ToggleControl(label: "Show Labels", isOn: $showLabel)

            ColorControl(label: "Tint Color", color: $tintColor)
        }
        .onAppear {
            if step == nil {
                step = 10
            }
        }
    }

    private var generatedCode: String {
        var code = """
        @State private var value = \(value)

        """

        if showLabel {
            if useStep, let step {
                code += """
                Slider(value: $value, in: \(Int(minValue))...\(Int(maxValue)), step: \(Int(step))) {
                    Text("Value")
                } minimumValueLabel: {
                    Text("\(Int(minValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxValue))")
                }
                """
            } else {
                code += """
                Slider(value: $value, in: \(Int(minValue))...\(Int(maxValue))) {
                    Text("Value")
                } minimumValueLabel: {
                    Text("\(Int(minValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxValue))")
                }
                """
            }
        } else {
            if useStep, let step {
                code += "Slider(value: $value, in: \(Int(minValue))...\(Int(maxValue)), step: \(Int(step)))"
            } else {
                code += "Slider(value: $value, in: \(Int(minValue))...\(Int(maxValue)))"
            }
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
        SliderPlayground()
    }
}
