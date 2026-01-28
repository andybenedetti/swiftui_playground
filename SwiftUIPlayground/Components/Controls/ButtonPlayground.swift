import SwiftUI

struct ButtonPlayground: View {
    @State private var buttonLabel = "Tap me"
    @State private var buttonStyle = ButtonStyleOption.automatic
    @State private var controlSize = ControlSizeOption.regular
    @State private var tintColor = Color.blue
    @State private var isDisabled = false
    @State private var tapCount = 0

    enum ButtonStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case bordered = "Bordered"
        case borderedProminent = "Bordered Prominent"
        case borderless = "Borderless"
        case plain = "Plain"
    }

    enum ControlSizeOption: String, CaseIterable {
        case mini = "Mini"
        case small = "Small"
        case regular = "Regular"
        case large = "Large"
        case extraLarge = "Extra Large"

        var controlSize: ControlSize {
            switch self {
            case .mini: .mini
            case .small: .small
            case .regular: .regular
            case .large: .large
            case .extraLarge: .extraLarge
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Button",
            description: "A control that initiates an action when tapped.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/button")!,
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
            buttonView
            Text("Tap count: \(tapCount)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var buttonView: some View {
        let button = Button(buttonLabel) {
            tapCount += 1
        }
        .tint(tintColor)
        .controlSize(controlSize.controlSize)
        .disabled(isDisabled)

        switch buttonStyle {
        case .automatic:
            button.buttonStyle(.automatic)
        case .bordered:
            button.buttonStyle(.bordered)
        case .borderedProminent:
            button.buttonStyle(.borderedProminent)
        case .borderless:
            button.buttonStyle(.borderless)
        case .plain:
            button.buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $buttonLabel)

            PickerControl(
                label: "Style",
                selection: $buttonStyle,
                options: ButtonStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Control Size",
                selection: $controlSize,
                options: ControlSizeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Tint Color", color: $tintColor)

            ToggleControl(label: "Disabled", isOn: $isDisabled)
        }
    }

    private var generatedCode: String {
        var code = """
        Button("\(buttonLabel)") {
            // Action
        }
        """

        switch buttonStyle {
        case .automatic:
            break
        case .bordered:
            code += "\n.buttonStyle(.bordered)"
        case .borderedProminent:
            code += "\n.buttonStyle(.borderedProminent)"
        case .borderless:
            code += "\n.buttonStyle(.borderless)"
        case .plain:
            code += "\n.buttonStyle(.plain)"
        }

        if tintColor != .blue {
            code += "\n.tint(\(colorToCode(tintColor)))"
        }

        if controlSize != .regular {
            code += "\n.controlSize(.\(controlSize.rawValue.lowercased().replacingOccurrences(of: " ", with: "")))"
        }

        if isDisabled {
            code += "\n.disabled(true)"
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
        if color == .yellow { return ".yellow" }
        return "Color(...)" // Custom color
    }
}

#Preview {
    NavigationStack {
        ButtonPlayground()
    }
}
