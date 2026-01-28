import SwiftUI

struct DividerPlayground: View {
    @State private var orientation = OrientationOption.horizontal
    @State private var padding: Double = 16
    @State private var showInContext = true

    enum OrientationOption: String, CaseIterable {
        case horizontal = "Horizontal"
        case vertical = "Vertical"
    }

    var body: some View {
        ComponentPage(
            title: "Divider",
            description: "A visual element used to separate content.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/divider")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        if showInContext {
            contextPreview
        } else {
            simplePreview
        }
    }

    @ViewBuilder
    private var simplePreview: some View {
        if orientation == .horizontal {
            VStack {
                Divider()
                    .padding(.horizontal, padding)
            }
            .frame(height: 50)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        } else {
            HStack {
                Divider()
                    .padding(.vertical, padding)
            }
            .frame(width: 50, height: 100)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }

    @ViewBuilder
    private var contextPreview: some View {
        if orientation == .horizontal {
            VStack(spacing: 0) {
                Text("Section 1")
                    .padding()
                Divider()
                    .padding(.horizontal, padding)
                Text("Section 2")
                    .padding()
                Divider()
                    .padding(.horizontal, padding)
                Text("Section 3")
                    .padding()
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        } else {
            HStack(spacing: 0) {
                Text("Left")
                    .padding()
                Divider()
                    .padding(.vertical, padding)
                Text("Center")
                    .padding()
                Divider()
                    .padding(.vertical, padding)
                Text("Right")
                    .padding()
            }
            .frame(height: 80)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Orientation",
                selection: $orientation,
                options: OrientationOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Padding",
                value: $padding,
                range: 0...40,
                format: "%.0f"
            )

            ToggleControl(label: "Show in Context", isOn: $showInContext)
        }
    }

    private var generatedCode: String {
        if orientation == .horizontal {
            if padding > 0 {
                return """
                VStack {
                    Text("Above")
                    Divider()
                        .padding(.horizontal, \(Int(padding)))
                    Text("Below")
                }
                """
            } else {
                return """
                VStack {
                    Text("Above")
                    Divider()
                    Text("Below")
                }
                """
            }
        } else {
            if padding > 0 {
                return """
                HStack {
                    Text("Left")
                    Divider()
                        .padding(.vertical, \(Int(padding)))
                    Text("Right")
                }
                """
            } else {
                return """
                HStack {
                    Text("Left")
                    Divider()
                    Text("Right")
                }
                """
            }
        }
    }
}

#Preview {
    NavigationStack {
        DividerPlayground()
    }
}
