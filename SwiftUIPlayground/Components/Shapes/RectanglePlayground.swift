import SwiftUI

struct RectanglePlayground: View {
    @State private var cornerRadius: Double = 0
    @State private var width: Double = 150
    @State private var height: Double = 100
    @State private var fillColor = Color.blue
    @State private var strokeColor = Color.blue
    @State private var strokeWidth: Double = 0
    @State private var useGradient = false

    var body: some View {
        ComponentPage(
            title: "Rectangle",
            description: "A rectangular shape with optional rounded corners.",
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
            .frame(width: width, height: height)
    }

    @ViewBuilder
    private var shapeView: some View {
        if cornerRadius > 0 {
            if strokeWidth > 0 {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(shapeFill)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(strokeColor, lineWidth: strokeWidth)
                    }
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(shapeFill)
            }
        } else {
            if strokeWidth > 0 {
                Rectangle()
                    .fill(shapeFill)
                    .overlay {
                        Rectangle()
                            .stroke(strokeColor, lineWidth: strokeWidth)
                    }
            } else {
                Rectangle()
                    .fill(shapeFill)
            }
        }
    }

    private var shapeFill: some ShapeStyle {
        if useGradient {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [fillColor, fillColor.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else {
            return AnyShapeStyle(fillColor)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(label: "Width", value: $width, range: 50...250, format: "%.0f")
            SliderControl(label: "Height", value: $height, range: 50...200, format: "%.0f")
            SliderControl(label: "Corner Radius", value: $cornerRadius, range: 0...50, format: "%.0f")

            ColorControl(label: "Fill Color", color: $fillColor)
            ToggleControl(label: "Use Gradient", isOn: $useGradient)

            SliderControl(label: "Stroke Width", value: $strokeWidth, range: 0...10, format: "%.0f")

            if strokeWidth > 0 {
                ColorControl(label: "Stroke Color", color: $strokeColor)
            }
        }
    }

    private var generatedCode: String {
        var code = ""
        let shapeType = cornerRadius > 0 ? "RoundedRectangle(cornerRadius: \(Int(cornerRadius)))" : "Rectangle()"

        if useGradient {
            code = """
            // \(cornerRadius > 0 ? "Rounded rectangle" : "Rectangle") with gradient
            \(shapeType)
                .fill(
                    LinearGradient(
                        colors: [\(colorToCode(fillColor)), \(colorToCode(fillColor)).opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: \(Int(width)), height: \(Int(height)))
            """
        } else {
            code = """
            // \(cornerRadius > 0 ? "Rounded rectangle" : "Rectangle")
            \(shapeType)
                .fill(\(colorToCode(fillColor)))
                .frame(width: \(Int(width)), height: \(Int(height)))
            """
        }

        if strokeWidth > 0 {
            code += """

                .overlay {
                    \(shapeType)
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
        if color == .yellow { return ".yellow" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        RectanglePlayground()
    }
}
