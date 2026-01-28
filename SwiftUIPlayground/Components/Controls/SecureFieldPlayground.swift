import SwiftUI

struct SecureFieldPlayground: View {
    @State private var password = ""
    @State private var promptText = "Enter password"
    @State private var showPassword = false
    @State private var textContentType = TextContentTypeOption.password
    @State private var submitLabel = SubmitLabelOption.done

    enum TextContentTypeOption: String, CaseIterable {
        case password = "Password"
        case newPassword = "New Password"
        case none = "None"
    }

    enum SubmitLabelOption: String, CaseIterable {
        case done = "Done"
        case go = "Go"
        case send = "Send"
        case continueAction = "Continue"

        var label: SubmitLabel {
            switch self {
            case .done: .done
            case .go: .go
            case .send: .send
            case .continueAction: .continue
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "SecureField",
            description: "A control into which the user securely enters private text.",
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
            if showPassword {
                TextField(promptText, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(submitLabel.label)
                    .frame(width: 250)
            } else {
                SecureField(promptText, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(submitLabel.label)
                    .frame(width: 250)
            }

            Button(showPassword ? "Hide Password" : "Show Password") {
                showPassword.toggle()
            }
            .buttonStyle(.bordered)

            if !password.isEmpty {
                Text("Length: \(password.count) characters")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(
                label: "Prompt",
                text: $promptText
            )

            PickerControl(
                label: "Submit Label",
                selection: $submitLabel,
                options: SubmitLabelOption.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Content Type",
                selection: $textContentType,
                options: TextContentTypeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            Text("SecureField masks user input for sensitive data like passwords.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        var code = """
        // Secure text field
        @State private var password = ""

        SecureField("\(promptText)", text: $password)
        """

        if submitLabel != .done {
            code += "\n    .submitLabel(.\(submitLabel.rawValue.lowercased()))"
        }

        code += "\n    .textFieldStyle(.roundedBorder)"

        return code
    }
}

#Preview {
    NavigationStack {
        SecureFieldPlayground()
    }
}
