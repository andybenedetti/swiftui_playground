import SwiftUI

struct TogglePlayground: View {
    @State private var isOn = true
    @State private var label = "Enable feature"
    @State private var toggleStyle = ToggleStyleOption.automatic
    @State private var tintColor = Color.green

    enum ToggleStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case button = "Button"
        case switchStyle = "Switch"
    }

    var body: some View {
        ComponentPage(
            title: "Toggle",
            description: "A control that toggles between on and off states.",
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
            toggleView
            Text("State: \(isOn ? "ON" : "OFF")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private var toggleView: some View {
        let toggle = Toggle(label, isOn: $isOn)
            .tint(tintColor)

        switch toggleStyle {
        case .automatic:
            toggle
        case .button:
            toggle.toggleStyle(.button)
        case .switchStyle:
            toggle.toggleStyle(.switch)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $label)

            PickerControl(
                label: "Style",
                selection: $toggleStyle,
                options: ToggleStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Tint Color", color: $tintColor)
        }
    }

    private var generatedCode: String {
        var code = """
        // Toggle control
        @State private var isOn = \(isOn)

        Toggle("\(label)", isOn: $isOn)
        """

        switch toggleStyle {
        case .automatic:
            break
        case .button:
            code += "\n    .toggleStyle(.button)"
        case .switchStyle:
            code += "\n    .toggleStyle(.switch)"
        }

        if tintColor != .green {
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
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        TogglePlayground()
    }
}
