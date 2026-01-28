import SwiftUI

struct SpacerPlayground: View {
    @State private var orientation = OrientationOption.horizontal
    @State private var spacerPosition = SpacerPositionOption.between
    @State private var minLength: Double = 0
    @State private var useMinLength = false

    enum OrientationOption: String, CaseIterable {
        case horizontal = "Horizontal"
        case vertical = "Vertical"
    }

    enum SpacerPositionOption: String, CaseIterable {
        case leading = "Leading/Top"
        case between = "Between"
        case trailing = "Trailing/Bottom"
        case both = "Both Ends"
    }

    var body: some View {
        ComponentPage(
            title: "Spacer",
            description: "A flexible space that expands along the major axis of its containing stack.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        if orientation == .horizontal {
            horizontalPreview
        } else {
            verticalPreview
        }
    }

    @ViewBuilder
    private var horizontalPreview: some View {
        HStack {
            switch spacerPosition {
            case .leading:
                spacerView
                contentBox("A")
                contentBox("B")
            case .between:
                contentBox("A")
                spacerView
                contentBox("B")
            case .trailing:
                contentBox("A")
                contentBox("B")
                spacerView
            case .both:
                spacerView
                contentBox("A")
                spacerView
                contentBox("B")
                spacerView
            }
        }
        .frame(height: 60)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var verticalPreview: some View {
        VStack {
            switch spacerPosition {
            case .leading:
                spacerView
                contentBox("A")
                contentBox("B")
            case .between:
                contentBox("A")
                spacerView
                contentBox("B")
            case .trailing:
                contentBox("A")
                contentBox("B")
                spacerView
            case .both:
                spacerView
                contentBox("A")
                spacerView
                contentBox("B")
                spacerView
            }
        }
        .frame(height: 200)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var spacerView: some View {
        if useMinLength {
            Spacer(minLength: minLength)
        } else {
            Spacer()
        }
    }

    private func contentBox(_ label: String) -> some View {
        Text(label)
            .font(.headline)
            .frame(width: 50, height: 50)
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(8)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Stack Direction",
                selection: $orientation,
                options: OrientationOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ParameterControl(label: "Spacer Position") {
                Picker("Position", selection: $spacerPosition) {
                    ForEach(SpacerPositionOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.menu)
            }

            ToggleControl(label: "Use Min Length", isOn: $useMinLength)

            if useMinLength {
                SliderControl(
                    label: "Min Length",
                    value: $minLength,
                    range: 0...100,
                    format: "%.0f"
                )
            }

            Text("Spacer expands to fill available space in the stack's main axis.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        let stackType = orientation == .horizontal ? "HStack" : "VStack"
        let spacerCode = useMinLength ? "Spacer(minLength: \(Int(minLength)))" : "Spacer()"

        switch spacerPosition {
        case .leading:
            return """
            // Spacer pushes content to trailing/bottom
            \(stackType) {
                \(spacerCode)
                ContentA()
                ContentB()
            }
            """
        case .between:
            return """
            // Spacer between items
            \(stackType) {
                ContentA()
                \(spacerCode)
                ContentB()
            }
            """
        case .trailing:
            return """
            // Spacer pushes content to leading/top
            \(stackType) {
                ContentA()
                ContentB()
                \(spacerCode)
            }
            """
        case .both:
            return """
            // Spacers center content
            \(stackType) {
                \(spacerCode)
                ContentA()
                \(spacerCode)
                ContentB()
                \(spacerCode)
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        SpacerPlayground()
    }
}
