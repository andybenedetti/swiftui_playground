import SwiftUI

struct ProgressViewPlayground: View {
    @State private var progressStyle = ProgressStyleOption.circular
    @State private var progress: Double = 0.5
    @State private var showLabel = true
    @State private var label = "Loading..."
    @State private var tintColor = Color.blue

    enum ProgressStyleOption: String, CaseIterable {
        case circular = "Circular"
        case linear = "Linear"
    }

    var body: some View {
        ComponentPage(
            title: "ProgressView",
            description: "A view that shows the progress of a task or an indeterminate loading state.",
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
            if showLabel {
                progressViewWithLabel
            } else {
                progressViewWithoutLabel
            }

            Text("\(Int(progress * 100))% complete")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private var progressViewWithLabel: some View {
        switch progressStyle {
        case .circular:
            ProgressView(label, value: progress)
                .tint(tintColor)
        case .linear:
            ProgressView(label, value: progress)
                .progressViewStyle(.linear)
                .tint(tintColor)
        }
    }

    @ViewBuilder
    private var progressViewWithoutLabel: some View {
        switch progressStyle {
        case .circular:
            ProgressView(value: progress)
                .tint(tintColor)
        case .linear:
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(tintColor)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Style",
                selection: $progressStyle,
                options: ProgressStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Progress",
                value: $progress,
                range: 0...1,
                format: "%.0f%%"
            )

            ToggleControl(label: "Show Label", isOn: $showLabel)

            if showLabel {
                TextFieldControl(label: "Label", text: $label)
            }

            ColorControl(label: "Tint Color", color: $tintColor)
        }
    }

    private var generatedCode: String {
        var code = "// ProgressView\n"

        if showLabel {
            code += "ProgressView(\"\(label)\", value: \(String(format: "%.2f", progress)))"
        } else {
            code += "ProgressView(value: \(String(format: "%.2f", progress)))"
        }

        if progressStyle == .linear {
            code += "\n    .progressViewStyle(.linear)"
        }

        if tintColor != .blue {
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
        ProgressViewPlayground()
    }
}
