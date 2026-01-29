import SwiftUI

struct AccessibilityLabelPlayground: View {
    // MARK: - State
    @State private var labelText = "Close"
    @State private var useCustomLabel = true
    @State private var showImage = true

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "accessibilityLabel",
            description: "Adds a label to a view that describes its contents for assistive technologies like VoiceOver.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/accessibilitylabel(_:)-1d7jv")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("Icon Button Example")
                    .font(.headline)

                if showImage {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.red)
                    }
                    .accessibilityLabel(useCustomLabel ? labelText : "xmark.circle.fill")
                }
            }

            VStack(spacing: 8) {
                Text("Rating Example")
                    .font(.headline)

                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < 3 ? "star.fill" : "star")
                            .foregroundStyle(index < 3 ? .yellow : .gray)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Rating: 3 out of 5 stars")
            }

            VStack(spacing: 8) {
                Text("VoiceOver reads:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(useCustomLabel ? "\"\(labelText)\"" : "\"xmark.circle.fill\"")
                    .font(.body.monospaced())
                    .foregroundStyle(.blue)
            }
            .padding()
            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Use Custom Label", isOn: $useCustomLabel)

            if useCustomLabel {
                TextFieldControl(label: "Label Text", text: $labelText)
            }

            ToggleControl(label: "Show Image", isOn: $showImage)

            Text("Without a label, VoiceOver reads the SF Symbol name literally.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        if useCustomLabel {
            return """
            Button {
                // action
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 44))
            }
            .accessibilityLabel("\(labelText)")
            """
        } else {
            return """
            // Without accessibilityLabel, VoiceOver reads
            // the SF Symbol name literally
            Button {
                // action
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 44))
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        AccessibilityLabelPlayground()
    }
}
