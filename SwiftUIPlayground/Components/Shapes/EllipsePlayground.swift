import SwiftUI

struct EllipsePlayground: View {
    @State private var width: Double = 200
    @State private var height: Double = 100
    @State private var fillColor: Color = .purple
    @State private var strokeWidth: Double = 0
    @State private var strokeColor: Color = .primary
    @State private var useTrim = false
    @State private var trimFrom: Double = 0
    @State private var trimTo: Double = 1

    var body: some View {
        ComponentPage(
            title: "Ellipse",
            description: "An ellipse aligned inside the frame of the view containing it.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/ellipse")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        if useTrim {
            if strokeWidth > 0 {
                Ellipse()
                    .trim(from: trimFrom, to: trimTo)
                    .stroke(strokeColor, lineWidth: strokeWidth)
                    .frame(width: width, height: height)
            } else {
                Ellipse()
                    .trim(from: trimFrom, to: trimTo)
                    .fill(fillColor)
                    .frame(width: width, height: height)
            }
        } else {
            if strokeWidth > 0 {
                Ellipse()
                    .fill(fillColor)
                    .overlay(
                        Ellipse()
                            .stroke(strokeColor, lineWidth: strokeWidth)
                    )
                    .frame(width: width, height: height)
            } else {
                Ellipse()
                    .fill(fillColor)
                    .frame(width: width, height: height)
            }
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

            ColorControl(label: "Fill Color", color: $fillColor)

            SliderControl(
                label: "Stroke Width",
                value: $strokeWidth,
                range: 0...10,
                format: "%.1f"
            )

            if strokeWidth > 0 {
                ColorControl(label: "Stroke Color", color: $strokeColor)
            }

            ToggleControl(label: "Use Trim", isOn: $useTrim)

            if useTrim {
                SliderControl(
                    label: "Trim From",
                    value: $trimFrom,
                    range: 0...1,
                    format: "%.2f"
                )

                SliderControl(
                    label: "Trim To",
                    value: $trimTo,
                    range: 0...1,
                    format: "%.2f"
                )
            }
        }
    }

    private var generatedCode: String {
        var code = "// Ellipse shape\n"

        if useTrim {
            code += "Ellipse()\n"
            code += "    .trim(from: \(String(format: "%.2f", trimFrom)), to: \(String(format: "%.2f", trimTo)))\n"
            if strokeWidth > 0 {
                code += "    .stroke(.\(strokeColor.description), lineWidth: \(String(format: "%.1f", strokeWidth)))"
            } else {
                code += "    .fill(.\(fillColor.description))"
            }
        } else {
            code += "Ellipse()\n"
            code += "    .fill(.\(fillColor.description))"
            if strokeWidth > 0 {
                code += "\n    .overlay(\n        Ellipse()\n            .stroke(.\(strokeColor.description), lineWidth: \(String(format: "%.1f", strokeWidth)))\n    )"
            }
        }

        code += "\n    .frame(width: \(Int(width)), height: \(Int(height)))"
        return code
    }
}

#Preview {
    NavigationStack {
        EllipsePlayground()
    }
}
