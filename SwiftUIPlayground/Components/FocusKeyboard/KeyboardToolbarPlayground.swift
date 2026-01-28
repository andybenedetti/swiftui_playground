import SwiftUI

struct KeyboardToolbarPlayground: View {
    @State private var text = ""
    @State private var number = ""
    @State private var showDoneButton = true
    @State private var showNavigationButtons = true
    @State private var toolbarPlacement = ToolbarPlacementOption.keyboard

    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isNumberFieldFocused: Bool

    enum ToolbarPlacementOption: String, CaseIterable {
        case keyboard = "Keyboard"
        case bottomBar = "Bottom Bar"
    }

    var body: some View {
        ComponentPage(
            title: "Keyboard Toolbar",
            description: "Add toolbar items above the keyboard using .toolbar with keyboard placement. iOS 15+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/toolbar(content:)-5w0tj")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Text Field")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Enter text...", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .focused($isTextFieldFocused)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Number Field")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Enter number...", text: $number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($isNumberFieldFocused)
            }

            Text("Tap a field to see the keyboard toolbar")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .toolbar {
            if toolbarPlacement == .keyboard {
                ToolbarItemGroup(placement: .keyboard) {
                    toolbarContent
                }
            } else {
                ToolbarItemGroup(placement: .bottomBar) {
                    toolbarContent
                }
            }
        }
    }

    @ViewBuilder
    private var toolbarContent: some View {
        if showNavigationButtons {
            Button(action: { moveToTextField() }) {
                Image(systemName: "chevron.up")
            }
            Button(action: { moveToNumberField() }) {
                Image(systemName: "chevron.down")
            }
        }

        Spacer()

        if showDoneButton {
            Button("Done") {
                isTextFieldFocused = false
                isNumberFieldFocused = false
            }
            .fontWeight(.semibold)
        }
    }

    private func moveToTextField() {
        isTextFieldFocused = true
        isNumberFieldFocused = false
    }

    private func moveToNumberField() {
        isTextFieldFocused = false
        isNumberFieldFocused = true
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Done Button", isOn: $showDoneButton)
            ToggleControl(label: "Show Navigation Buttons", isOn: $showNavigationButtons)

            PickerControl(
                label: "Toolbar Placement",
                selection: $toolbarPlacement,
                options: ToolbarPlacementOption.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        var code = """
        struct FormView: View {
            @State private var text = ""
            @FocusState private var isFocused: Bool

            var body: some View {
                TextField("Enter text...", text: $text)
                    .focused($isFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
        """

        if showNavigationButtons {
            code += """

                            Button(action: { /* previous */ }) {
                                Image(systemName: "chevron.up")
                            }
                            Button(action: { /* next */ }) {
                                Image(systemName: "chevron.down")
                            }
        """
        }

        code += """

                            Spacer()
        """

        if showDoneButton {
            code += """

                            Button("Done") {
                                isFocused = false
                            }
        """
        }

        code += """

                        }
                    }
            }
        }
        """

        return code
    }
}

#Preview {
    NavigationStack {
        KeyboardToolbarPlayground()
    }
}
