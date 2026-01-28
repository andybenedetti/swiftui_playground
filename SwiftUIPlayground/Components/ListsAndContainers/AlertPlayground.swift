import SwiftUI

struct AlertPlayground: View {
    @State private var showAlert = false
    @State private var showConfirmation = false
    @State private var alertStyle = AlertStyleOption.alert
    @State private var title = "Alert Title"
    @State private var message = "This is the alert message."
    @State private var showDestructive = false
    @State private var lastAction = "None"

    enum AlertStyleOption: String, CaseIterable {
        case alert = "Alert"
        case confirmationDialog = "Confirmation Dialog"
    }

    var body: some View {
        ComponentPage(
            title: "Alert",
            description: "A modal view that displays important information and optionally requests user action.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/alert(_:ispresented:actions:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
        .alert(title, isPresented: $showAlert) {
            Button("OK") {
                lastAction = "OK"
            }
            if showDestructive {
                Button("Delete", role: .destructive) {
                    lastAction = "Delete"
                }
            }
            Button("Cancel", role: .cancel) {
                lastAction = "Cancel"
            }
        } message: {
            Text(message)
        }
        .confirmationDialog(title, isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Option 1") {
                lastAction = "Option 1"
            }
            Button("Option 2") {
                lastAction = "Option 2"
            }
            if showDestructive {
                Button("Delete", role: .destructive) {
                    lastAction = "Delete"
                }
            }
            Button("Cancel", role: .cancel) {
                lastAction = "Cancel"
            }
        } message: {
            Text(message)
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            Button("Show \(alertStyle.rawValue)") {
                if alertStyle == .alert {
                    showAlert = true
                } else {
                    showConfirmation = true
                }
            }
            .buttonStyle(.borderedProminent)

            Text("Last action: \(lastAction)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $alertStyle,
                options: AlertStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            TextFieldControl(label: "Title", text: $title)
            TextFieldControl(label: "Message", text: $message)

            ToggleControl(label: "Show Destructive Action", isOn: $showDestructive)
        }
    }

    private var generatedCode: String {
        if alertStyle == .confirmationDialog {
            var code = """
            // Confirmation dialog
            @State private var showDialog = false

            Button("Show Dialog") {
                showDialog = true
            }
            .confirmationDialog("\(title)", isPresented: $showDialog, titleVisibility: .visible) {
                Button("Option 1") { }
                Button("Option 2") { }
            """

            if showDestructive {
                code += "\n    Button(\"Delete\", role: .destructive) { }"
            }

            code += """

                Button("Cancel", role: .cancel) { }
            } message: {
                Text("\(message)")
            }
            """

            return code
        }

        var code = """
        // Alert
        @State private var showAlert = false

        Button("Show Alert") {
            showAlert = true
        }
        .alert("\(title)", isPresented: $showAlert) {
            Button("OK") { }
        """

        if showDestructive {
            code += "\n    Button(\"Delete\", role: .destructive) { }"
        }

        code += """

            Button("Cancel", role: .cancel) { }
        } message: {
            Text("\(message)")
        }
        """

        return code
    }
}

#Preview {
    NavigationStack {
        AlertPlayground()
    }
}
