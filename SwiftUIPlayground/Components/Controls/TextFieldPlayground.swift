import SwiftUI

struct TextFieldPlayground: View {
    @State private var text = ""
    @State private var placeholder = "Enter text"
    @State private var textFieldStyle = TextFieldStyleOption.automatic
    @State private var keyboardType = KeyboardTypeOption.default
    @State private var autocapitalization = AutocapitalizationOption.sentences
    @State private var isSecure = false

    enum TextFieldStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case plain = "Plain"
        case roundedBorder = "Rounded Border"
    }

    enum KeyboardTypeOption: String, CaseIterable {
        case `default` = "Default"
        case emailAddress = "Email"
        case numberPad = "Number Pad"
        case phonePad = "Phone"
        case url = "URL"

        var keyboardType: UIKeyboardType {
            switch self {
            case .default: .default
            case .emailAddress: .emailAddress
            case .numberPad: .numberPad
            case .phonePad: .phonePad
            case .url: .URL
            }
        }
    }

    enum AutocapitalizationOption: String, CaseIterable {
        case never = "Never"
        case words = "Words"
        case sentences = "Sentences"
        case characters = "Characters"

        var autocapitalization: TextInputAutocapitalization {
            switch self {
            case .never: .never
            case .words: .words
            case .sentences: .sentences
            case .characters: .characters
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "TextField",
            description: "A control for entering and editing text.",
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
            textFieldView
                .padding(.horizontal, 20)

            if !text.isEmpty {
                Text("Value: \(text)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var textFieldView: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
        } else {
            let field = TextField(placeholder, text: $text)
                .keyboardType(keyboardType.keyboardType)
                .textInputAutocapitalization(autocapitalization.autocapitalization)

            switch textFieldStyle {
            case .automatic:
                field
            case .plain:
                field.textFieldStyle(.plain)
            case .roundedBorder:
                field.textFieldStyle(.roundedBorder)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Placeholder", text: $placeholder)

            ToggleControl(label: "Secure Entry", isOn: $isSecure)

            if !isSecure {
                PickerControl(
                    label: "Style",
                    selection: $textFieldStyle,
                    options: TextFieldStyleOption.allCases,
                    optionLabel: { $0.rawValue }
                )

                PickerControl(
                    label: "Keyboard",
                    selection: $keyboardType,
                    options: KeyboardTypeOption.allCases,
                    optionLabel: { $0.rawValue }
                )

                PickerControl(
                    label: "Autocapitalization",
                    selection: $autocapitalization,
                    options: AutocapitalizationOption.allCases,
                    optionLabel: { $0.rawValue }
                )
            }
        }
    }

    private var generatedCode: String {
        if isSecure {
            return """
            // SecureField for password entry
            @State private var text = ""

            SecureField("\(placeholder)", text: $text)
            """
        }

        var code = """
        // TextField control
        @State private var text = ""

        TextField("\(placeholder)", text: $text)
        """

        switch textFieldStyle {
        case .automatic:
            break
        case .plain:
            code += "\n    .textFieldStyle(.plain)"
        case .roundedBorder:
            code += "\n    .textFieldStyle(.roundedBorder)"
        }

        if keyboardType != .default {
            code += "\n    .keyboardType(.\(keyboardType.rawValue.lowercased().replacingOccurrences(of: " ", with: "")))"
        }

        if autocapitalization != .sentences {
            code += "\n    .textInputAutocapitalization(.\(autocapitalization.rawValue.lowercased()))"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        TextFieldPlayground()
    }
}
