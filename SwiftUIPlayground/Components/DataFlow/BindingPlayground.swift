import SwiftUI

struct BindingPlayground: View {
    @State private var parentValue = 50.0
    @State private var parentText = "Parent owns this"
    @State private var showConstant = false

    var body: some View {
        ComponentPage(
            title: "@Binding",
            description: "A property wrapper that creates a two-way connection to a source of truth. iOS 13+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/binding")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 24) {
            // Parent view section
            VStack(spacing: 8) {
                Label("Parent View", systemImage: "rectangle")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("Value: \(Int(parentValue))")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Text: \"\(parentText)\"")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            Image(systemName: "arrow.up.arrow.down")
                .font(.title2)
                .foregroundStyle(.secondary)

            // Child view section
            VStack(spacing: 8) {
                Label("Child View (receives @Binding)", systemImage: "rectangle.inset.filled")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ChildSliderView(value: $parentValue)
                ChildTextView(text: $parentText)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)

            if showConstant {
                VStack(spacing: 8) {
                    Label("Constant Binding (read-only)", systemImage: "lock")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ChildSliderView(value: .constant(75))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Parent Value",
                value: $parentValue,
                range: 0...100
            )

            TextFieldControl(label: "Parent Text", text: $parentText)

            ToggleControl(label: "Show Constant Binding", isOn: $showConstant)
        }
    }

    private var generatedCode: String {
        var code = """
        // Parent view owns the state
        struct ParentView: View {
            @State private var value = 50.0

            var body: some View {
                // Pass binding to child with $
                ChildView(value: $value)
            }
        }

        // Child view receives binding
        struct ChildView: View {
            @Binding var value: Double

            var body: some View {
                Slider(value: $value, in: 0...100)
            }
        }
        """

        if showConstant {
            code += """


        // Constant binding (read-only)
        ChildView(value: .constant(75))
        """
        }

        return code
    }
}

// MARK: - Child Views

private struct ChildSliderView: View {
    @Binding var value: Double

    var body: some View {
        VStack {
            Text("Child controls: \(Int(value))")
                .font(.subheadline)
            Slider(value: $value, in: 0...100)
        }
    }
}

private struct ChildTextView: View {
    @Binding var text: String

    var body: some View {
        TextField("Child edits parent's text", text: $text)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    NavigationStack {
        BindingPlayground()
    }
}
