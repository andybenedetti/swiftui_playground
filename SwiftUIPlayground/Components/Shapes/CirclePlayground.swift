import SwiftUI

struct CirclePlayground: View {
    @State private var shapeType = ShapeTypeOption.circle
    @State private var size: Double = 150
    @State private var fillColor = Color.blue
    @State private var strokeColor = Color.blue
    @State private var strokeWidth: Double = 0
    @State private var useGradient = false
    @State private var trimFrom: Double = 0
    @State private var trimTo: Double = 1

    enum ShapeTypeOption: String, CaseIterable {
        case circle = "Circle"
        case ellipse = "Ellipse"
        case capsule = "Capsule"
    }

    var body: some View {
        ComponentPage(
            title: "Circle",
            description: "A circle shape, plus ellipse and capsule variants.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/circle")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        shapeView
            .frame(
                width: shapeType == .capsule ? size * 1.5 : size,
                height: shapeType == .ellipse ? size * 0.6 : size
            )
    }

    @ViewBuilder
    private var shapeView: some View {
        switch shapeType {
        case .circle:
            circleShape
        case .ellipse:
            ellipseShape
        case .capsule:
            capsuleShape
        }
    }

    @ViewBuilder
    private var circleShape: some View {
        if strokeWidth > 0 {
            Circle()
                .trim(from: trimFrom, to: trimTo)
                .fill(shapeFill)
                .overlay {
                    Circle()
                        .trim(from: trimFrom, to: trimTo)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                }
        } else {
            Circle()
                .trim(from: trimFrom, to: trimTo)
                .fill(shapeFill)
        }
    }

    @ViewBuilder
    private var ellipseShape: some View {
        if strokeWidth > 0 {
            Ellipse()
                .trim(from: trimFrom, to: trimTo)
                .fill(shapeFill)
                .overlay {
                    Ellipse()
                        .trim(from: trimFrom, to: trimTo)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                }
        } else {
            Ellipse()
                .trim(from: trimFrom, to: trimTo)
                .fill(shapeFill)
        }
    }

    @ViewBuilder
    private var capsuleShape: some View {
        if strokeWidth > 0 {
            Capsule()
                .fill(shapeFill)
                .overlay {
                    Capsule()
                        .stroke(strokeColor, lineWidth: strokeWidth)
                }
        } else {
            Capsule()
                .fill(shapeFill)
        }
    }

    private var shapeFill: some ShapeStyle {
        if useGradient {
            return AnyShapeStyle(
                RadialGradient(
                    colors: [fillColor, fillColor.opacity(0.3)],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
        } else {
            return AnyShapeStyle(fillColor)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Shape",
                selection: $shapeType,
                options: ShapeTypeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(label: "Size", value: $size, range: 50...200, format: "%.0f")

            ColorControl(label: "Fill Color", color: $fillColor)
            ToggleControl(label: "Use Gradient", isOn: $useGradient)

            SliderControl(label: "Stroke Width", value: $strokeWidth, range: 0...10, format: "%.0f")

            if strokeWidth > 0 {
                ColorControl(label: "Stroke Color", color: $strokeColor)
            }

            if shapeType != .capsule {
                SliderControl(label: "Trim From", value: $trimFrom, range: 0...1, format: "%.2f")
                SliderControl(label: "Trim To", value: $trimTo, range: 0...1, format: "%.2f")
            }
        }
    }

    private var generatedCode: String {
        var code = ""
        let shapeCode = shapeType.rawValue

        if useGradient {
            code += """
            // \(shapeCode) with radial gradient
            \(shapeCode)()
            """

            if shapeType != .capsule && (trimFrom > 0 || trimTo < 1) {
                code += "\n    .trim(from: \(String(format: "%.2f", trimFrom)), to: \(String(format: "%.2f", trimTo)))"
            }

            code += """

                .fill(
                    RadialGradient(
                        colors: [\(colorToCode(fillColor)), \(colorToCode(fillColor)).opacity(0.3)],
                        center: .center,
                        startRadius: 0,
                        endRadius: \(Int(size / 2))
                    )
                )
                .frame(width: \(Int(size)), height: \(Int(size)))
            """
        } else {
            code += """
            // \(shapeCode)
            \(shapeCode)()
            """

            if shapeType != .capsule && (trimFrom > 0 || trimTo < 1) {
                code += "\n    .trim(from: \(String(format: "%.2f", trimFrom)), to: \(String(format: "%.2f", trimTo)))"
            }

            code += """

                .fill(\(colorToCode(fillColor)))
                .frame(width: \(Int(size)), height: \(Int(size)))
            """
        }

        if strokeWidth > 0 {
            code += """

                .overlay {
                    \(shapeCode)()
                        .stroke(\(colorToCode(strokeColor)), lineWidth: \(Int(strokeWidth)))
                }
            """
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
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        CirclePlayground()
    }
}
