import SwiftUI

struct RoundedRectanglePlayground: View {
    @State private var width: Double = 200
    @State private var height: Double = 120
    @State private var cornerRadius: Double = 20
    @State private var fillColor: Color = .green
    @State private var strokeWidth: Double = 0
    @State private var strokeColor: Color = .primary
    @State private var style = CornerStyleOption.circular

    enum CornerStyleOption: String, CaseIterable {
        case circular = "Circular"
        case continuous = "Continuous"

        var style: RoundedCornerStyle {
            switch self {
            case .circular: .circular
            case .continuous: .continuous
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "RoundedRectangle",
            description: "A rectangular shape with rounded corners, aligned inside the frame of the view containing it.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/roundedrectangle")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        if strokeWidth > 0 {
            RoundedRectangle(cornerRadius: cornerRadius, style: style.style)
                .fill(fillColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: style.style)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                )
                .frame(width: width, height: height)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: style.style)
                .fill(fillColor)
                .frame(width: width, height: height)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Width",
                value: $width,
                range: 50...300,
                format: "%.0f"
            )

            SliderControl(
                label: "Height",
                value: $height,
                range: 50...200,
                format: "%.0f"
            )

            SliderControl(
                label: "Corner Radius",
                value: $cornerRadius,
                range: 0...60,
                format: "%.0f"
            )

            ColorControl(label: "Fill Color", color: $fillColor)

            PickerControl(
                label: "Style",
                selection: $style,
                options: CornerStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Stroke Width",
                value: $strokeWidth,
                range: 0...10,
                format: "%.1f"
            )

            if strokeWidth > 0 {
                ColorControl(label: "Stroke Color", color: $strokeColor)
            }
        }
    }

    private var generatedCode: String {
        var code = "// Rounded rectangle shape\n"

        if style == .continuous {
            code += "RoundedRectangle(cornerRadius: \(Int(cornerRadius)), style: .continuous)\n"
        } else {
            code += "RoundedRectangle(cornerRadius: \(Int(cornerRadius)))\n"
        }

        code += "    .fill(.\(fillColor.description))"

        if strokeWidth > 0 {
            code += "\n    .overlay(\n"
            if style == .continuous {
                code += "        RoundedRectangle(cornerRadius: \(Int(cornerRadius)), style: .continuous)\n"
            } else {
                code += "        RoundedRectangle(cornerRadius: \(Int(cornerRadius)))\n"
            }
            code += "            .stroke(.\(strokeColor.description), lineWidth: \(String(format: "%.1f", strokeWidth)))\n    )"
        }

        code += "\n    .frame(width: \(Int(width)), height: \(Int(height)))"
        return code
    }
}

#Preview {
    NavigationStack {
        RoundedRectanglePlayground()
    }
}
